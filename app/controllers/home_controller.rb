class HomeController < ApplicationController
  def index
    @forecast_request = ForecastRequest.new
  end

  def forecast
    @forecast_request = ForecastRequest.new(forecast_params)

    if @forecast_request.valid?
      
    else
      render :index, status: :unprocessable_entity
    end
  end

  def forecast_params
    params.expect(forecast_request: [:street, :city, :state, :zip_code])
  end
end
