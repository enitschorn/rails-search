class Flat < ApplicationRecord
  belongs_to :user
  validates :name, :price_per_night, :number_of_guests, :address, :description, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
