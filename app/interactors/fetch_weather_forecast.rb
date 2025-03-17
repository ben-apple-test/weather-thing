class FetchWeatherForecast
  include Interactor

  def call
    context.result = {
      is_cached: cached_data?,
      zip_code: zip_code,
      forecast: fetch_data(:forecast),
      current_temperature: fetch_data(:temperature)
    }
  end

  def read_cache(key)
    Rails.cache.read(cache_key_for(key))
  end

  def write_cache(key, value)
    Rails.cache.write(cache_key_for(key), value, expires_in: cache_ttl)
  end

  def cached_data?
    !!(read_cache(:forecast) && read_cache(:temperature))
  end

  def fetch_data(type)
    read_cache(type) || fetch_and_cache_weather_data(type)
  end

  def fetch_and_cache_weather_data(type)
    coords = latitude_and_longitude
    raise "Unable to geocode zip code" if coords.nil? || coords.empty?

    data = fetch_from_service(type, *coords)
    write_cache(type, data)
    data
  rescue StandardError => e
    context.fail!(error: "Failed to fetch #{type}: #{e.message}")
  end

  def fetch_from_service(type, latitude, longitude)
    case type
    when :forecast
      weather_service.forecast(latitude, longitude)
    when :temperature
      weather_service.current_temperature(latitude, longitude)
    end
  end

  def latitude_and_longitude
    @latitude_longitude ||= Geocoder.coordinates("#{context.street} #{context.city}, #{context.state} #{context.zip_code} USA")
  end

  def weather_service
    @weather_service ||= Weather::OpenMeteo.new
  end

  def cache_key_for(key)
    "#{key}_#{zip_code}"
  end

  def zip_code
    context.zip_code
  end

  def cache_ttl
    30.minutes
  end
end
