class FlatsController < ApplicationController
  before_action :set_flat, only: %i[ show edit update destroy ]

  # GET /flats or /flats.json
  def index
    if params[:query].present?
      sql_query = <<~SQL
        flats.name @@ :query
        OR flats.description @@ :query
        OR flats.address @@ :query
      SQL
      @flats = policy_scope(Flat.where(sql_query, query: "%#{params[:query]}%"))
    else
      @flats = policy_scope(Flat.all)
    end
    @markers = @flats.geocoded.map do |flat|
      {
        lat: flat.latitude,
        lng: flat.longitude,
        info_window: render_to_string(partial: "info_window", locals: {flat: flat}),
        image_url: helpers.asset_url("logo.png")
      }
    end
  end

  # GET /flats/1 or /flats/1.json
  def show
    authorize @flat
  end

  # GET /flats/new
  def new
    @flat = Flat.new
    authorize @flat
  end

  # GET /flats/1/edit
  def edit
    authorize @flat
  end

  # POST /flats or /flats.json
  def create
    @flat = Flat.new(flat_params)
    @flat.user = current_user
    authorize @flat

    respond_to do |format|
      if @flat.save
        format.html { redirect_to flat_url(@flat), notice: "Flat was successfully created." }
        format.json { render :show, status: :created, location: @flat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @flat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flats/1 or /flats/1.json
  def update
    authorize @flat
    respond_to do |format|
      if @flat.update(flat_params)
        format.html { redirect_to flat_url(@flat), notice: "Flat was successfully updated." }
        format.json { render :show, status: :ok, location: @flat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @flat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flats/1 or /flats/1.json
  def destroy
    authorize @flat
    @flat.destroy

    respond_to do |format|
      format.html { redirect_to flats_url, notice: "Flat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flat
      @flat = Flat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def flat_params
      params.require(:flat).permit(:name, :address, :description, :price_per_night, :number_of_guests)
    end
end
