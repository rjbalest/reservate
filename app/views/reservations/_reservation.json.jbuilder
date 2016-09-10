json.extract! reservation, :id, :user_id, :asset_id, :start_time, :end_time, :notes, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)