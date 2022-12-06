class Flat < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  validates :name, :price_per_night, :number_of_guests, :address, :description, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  include PgSearch::Model
  pg_search_scope :search_by_name_and_description_and_address,
    against: [ :name, :description, :address ],
    using: {
      tsearch: { prefix: true }
    }

  def unavailable_dates
    bookings.pluck(:start_date, :end_date).map do |range|
      { from: range[0], to: range[1] }
    end
  end

  def average_rating
    reviews = self.reviews
    total = 0
    reviews.each do |review|
      total += review.rating
    end
    unless total == 0
      total / reviews.count
    else
      0
    end
  end
end
