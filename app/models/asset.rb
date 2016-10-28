require "rest-client"

class Asset
  include ActiveModel::Model
  #< ApplicationRecord

  #has_many :reservations, dependent: :destroy

  attr_accessor :id,:name,:label,:description,:ip_address

  @@assets=nil

  def initialize(attributes={})
    super
  end

  def self.order(by)
    if @@assets.nil?
      @@assets = self.all
    end
    @@assets
  end

  def self.all
    assets = []
    num = 1
    response = RestClient.get self.uri, :accept=>:json
    json = JSON.parse(response)
    json.each do |s|

      hh = Hash.new
      hh['id'] = s['name']
      hh['name'] = s["name"]
      hh['label'] = "Server-%d" % num
      hh['description'] = "Big Server"
      hh['ip_address'] = "0.0.0.0"

      asset = Asset.new(hh)
      assets << asset
      num += 1
    end
    assets
  end

  def self.find(id)
    #
    asset = nil
    assets = self.all
    assets.each do |aa|
      if aa.id == id
        asset = aa
      end
    end
    asset
  end

  def persisted?
    if id.nil?
      false
    else
      true
    end
  end

  def self.uri
    'http://raj-tmp.ddns.me/api/servers'
  end
end
