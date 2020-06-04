class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :index, :show]

  def home
    @offers = Offer.where.not(id: AcceptedOffer.select(:offer_id).uniq)

    client_ip = request.remote_ip
    # If testing from local host, ip will set to a known London ip
    if client_ip == "::1"
      client_ip = "5.62.43.181"
    end

    @user_location = Geocoder.search(client_ip).first.coordinates
  
    @offers_near = Offer.joins(:category).geocoded.near(@user_location, 100)

    @markers = @offers_near.map do |offer|
      {
        lat: offer.latitude,
        lng: offer.longitude
      }
    end
  end
end
