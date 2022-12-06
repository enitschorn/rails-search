class PagesController < ApplicationController
  def home
  end

  def dashboard
    @user = User.find(current_user[:id])
    @bookings = @user.bookings
    @flats = @user.flats
  end
end
