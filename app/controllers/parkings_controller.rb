class ParkingsController < ApplicationController
  before_action :set_parking, only: [:edit, :update, :destroy]

  def index
    @parkings = Parking.all
  end

  def new
    @parking = Parking.new
  end

  def create
    @parking = Parking.new(parking_params)
    @parking.district = @parking.zip_code[0..1] == "75" ? @parking.zip_code[3..4] : "0"
    gps = Geokit::Geocoders::GoogleGeocoder.geocode(@parking.address + ", " + @parking.city)
    @parking.lat = gps.ll.split(',').first.to_f
    @parking.lng = gps.ll.split(',').last.to_f
    if @parking.save
      redirect_to "/"
    else
      render :new
    end
  end

  def destroy
    @parking.destroy
    redirect_to "/"
  end

  private

  def parking_params
    params.require(:parking).permit(:name, :address, :available, :has_camera, :has_watchman, :city, :zip_code, :main_picture, :price_month)
  end

  def set_parking
    @parking = Parking.find(params[:id])
  end

end
