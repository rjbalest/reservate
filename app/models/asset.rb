class Asset < ApplicationRecord

  has_many :reservations, dependent: :destroy
end
