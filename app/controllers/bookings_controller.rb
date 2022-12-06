class BookingsController < ApplicationController
  before_action :set_flat, only: %i[show create destroy new]

  def index
    @bookings = policy_scope(Booking)
  end

  def new
    @booking = Booking.new
    authorize @booking
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @booking.flat = @flat
    date = @booking.end_date.mjd - @booking.start_date.mjd + 1
    @booking.total_price = @booking.flat.price_per_night * date
    authorize @booking
    if @booking.save
      redirect_to flat_path(@flat)
    else
      render :new, status: :unprocessable_entity
    end
  end

   def edit
    @booking = Booking.find(params[:id])
    @flat = @booking.flat
    authorize @booking
  end

  def update
    @booking = Booking.find(params[:id])
    @booking.update(booking_params)
    authorize @booking
    redirect_to dashboard_path(@booking.id)
  end


  def destroy
    authorize @booking
  end

  private

  def set_flat
    @flat = Flat.find(params[:flat_id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :status)
  end
end
