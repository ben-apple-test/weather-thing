class HomeController < ApplicationController
  def index
    @forecast_request = ForecastRequest.new
  end

  def forecast
    @forecast_request = ForecastRequest.new(forecast_params)

    if @forecast_request.valid? && fetch_forecast_result.success?
      @forecast = fetch_forecast_result.result
      debugger
    else
      render :index, status: :unprocessable_entity
    end
  end

  def forecast_params
    params.expect(forecast_request: [ :street, :city, :state, :zip_code ])
  end

  def fetch_forecast_result
    @forecast_result ||= FetchWeatherForecast.call(forecast_params)
  end
end
