class FetchWeatherForecast
  include Interactor

  CACHE_TTL = 30.minutes

  def call
    cached_forecast = read_forecast_cache

    context.result = {
      is_cached: !cached_forecast.nil?,
      zip_code: context.zip_code,
      forecast: cached_forecast || fetch_and_cache_forecast
    }
  end

  def read_forecast_cache
    Rails.cache.read forecast_cache_key
  end

  def write_cached_forecast(forecast)
    Rails.cache.write forecast_cache_key, forecast, expires_in: CACHE_TTL
  end

  def forecast_cache_key
    "forecast_#{context.zip_code}"
  end

  def fetch_and_cache_forecast
    forecast_service = Weather::OpenMeteo.new
    latitude, longitude = Geocoder.coordinates(context.zip_code)
    
    raise "Unable to geocode zip code" if latitude.nil? || longitude.nil?
    
    forecast = forecast_service.forecast(latitude, longitude)
    write_cached_forecast(forecast)
    forecast
  rescue StandardError => e
    context.fail!(error: e.message)
  end
end
