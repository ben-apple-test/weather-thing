module Weather
  # Uses the Open Meteo API to get a simple weather forecast. There are a lot of options to use for this weather
  # service. We're just using a small slice of them to get a simple forecast for the next 7 dayes
  # https://open-meteo.com/en/docs
  class OpenMeteo
    BASE = "https://api.open-meteo.com/v1/forecast".freeze

    attr_reader :client

    def initialize(client=nil)
      @client = client || Http::Ruby.new
    end

    # Returns a simple weather forecast for the next 7 days as an array of hashes
    # Each hash contains the date, max_temp, min_temp, and precipitation
    # Temperatures are reported in Celsius
    # Precipitation is reported in millimeters
    def forecast(latitude, longitude)
      raise ArgumentError, "Invalid latitude" unless latitude.between?(-90, 90)
      raise ArgumentError, "Invalid longitude" unless longitude.between?(-180, 180)

      forecast = client.get(
        BASE,
        {
          latitude: latitude,
          longitude: longitude,
          daily: 'apparent_temperature_max,apparent_temperature_min,precipitation_sum',
        }
      )

      forecast['daily']['time'].map.with_index do |date, index|
        {
          date: date,
          max_temp: forecast['daily']['apparent_temperature_max'][index],
          min_temp: forecast['daily']['apparent_temperature_min'][index],
          precipitation: forecast['daily']['precipitation_sum'][index],
        }
      end
    rescue JSON::ParserError, Http::Error => e
      raise "Weather forecast failed: #{e.message}"
    end
  end
end
