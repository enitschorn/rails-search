class Flat < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  validates :name, :price_per_night, :number_of_guests, :address, :description, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def unavailable_dates
    bookings.pluck(:start_date, :end_date).map do |range|
      { from: range[0], to: range[1] }
    end
  end
end
