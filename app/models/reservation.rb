class Reservation
  #< ApplicationRecord
  include ActiveModel::Model

  #belongs_to :user
  #belongs_to :asset

  attr_accessor :id,:name,:start_time,:end_time,:notes,:approved,:approval_id,:asset,:user

  attr_accessor :asset_id
  attr_accessor :server_name,:start_date,:end_date,:approved

  @@reservations=nil

  def initialize(attributes={})
    super
  end

  def self.order(by)
    if @@reservations.nil?
      @@reservations = self.all
    end
    @@reservations
  end

  def self.all
    reservations = []
    num = 1
    response = RestClient.get self.uri, :accept=>:json
    json = JSON.parse(response)
    json.each do |s|

      hh = Hash.new
      hh['id'] = s['name']

      tt = s["start_date"].to_i / 1000
      hh['start_time'] = Time.at(tt).to_datetime
      tt = s["end_date"].to_i / 1000
      hh['end_time'] = Time.at(tt).to_datetime

      hh['approved'] = s['approved']
      hh['approval_id'] = s['approval_id']

      hh['asset'] = Asset.new(id:s['server_name'],name:s['server_name'])
      hh['user']  = User.new do |u|
        u.email = 'anonymous@reservate.com'
      end

      hh['notes'] = s['name']

      reservation = Reservation.new(hh)
      #reservation.asset =
      reservations << reservation
      num += 1
    end
    reservations
  end

  def self.find(id)
    #path = "%s/%s" % [self.uri, id]
    #response = RestClient.get self.uri, :accept=>:json
    #hh = JSON.parse(response)
    #h2 = self.reverse_map(hh)
    #reservation = Reservation.new(h2)
    reservation = nil
    reservations = self.all
    reservations.each do |res|
      if res.id == id
        reservation = res
      end
    end
    reservation
  end

  def destroy
    path = "%s/%s" % [Reservation.uri, self.id]
    response = RestClient.delete path, :accept=>:json
  end

  def self.reverse_map(s)
    hh = {}
    hh['id'] = s['name']

    hh['start_time'] = s["start_date"]
    hh['end_time'] = s["end_date"]
    hh['approved'] = s['approved']
    hh['approval_id'] = s['approval_id']

    hh['asset'] = Asset.new(id:s['server_name'],name:s['server_name'])
    hh['user']  = User.new do |u|
      u.email = 'anonymous@reservate.com'
    end

    hh['notes'] = s['name']
    hh
  end

  def self.map_params(params)
    hh = {}
    hh[:name] = params['notes']
    hh['start_date'] = DateTime.new(params["start_time(1i)"].to_i,
                                    params["start_time(2i)"].to_i,
                                    params["start_time(3i)"].to_i,
                                    params["start_time(4i)"].to_i,
                                    params["start_time(5i)"].to_i)

    hh['end_date'] = DateTime.new(params["end_time(1i)"].to_i,
                                  params["end_time(2i)"].to_i,
                                  params["end_time(3i)"].to_i,
                                  params["end_time(4i)"].to_i,
                                  params["end_time(5i)"].to_i)

    hh['server_name'] = params['asset_id']
    hh['approved'] = false
    hh
  end

  # @return [Object]
  def save
    response = RestClient.post Reservation.uri, self.to_json, :content_type=>:json, :accept=>:json
    print response
    true
  end

  def persisted?
    if id.nil?
      false
    else
      true
    end
  end

  def self.uri
    'http://raj-tmp.ddns.me/api/reservations'
  end
end
