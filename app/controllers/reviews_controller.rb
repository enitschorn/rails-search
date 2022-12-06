class ReviewsController < ApplicationController
  def new
    @flat = Flat.find(params[:flat_id])
    @review = Review.new
    authorize @review
  end

  def create
    @flat = Flat.find(params[:flat_id])
    @review = Review.new(review_params)
    @review.flat = @flat
    authorize @review
    @review.save
    redirect_to flat_path(@flat)
  end

  private

  def review_params
    params.require(:review).permit(:rating, :description)
  end
end
