module Weather
  # https://api.open-meteo.com/v1/forecast?latitude=52.52&amp;longitude=13.41&amp;current=temperature_2m,wind_speed_10m&amp;hourly=temperature_2m,relative_humidity_2m,wind_speed_10m
  class OpenMeteo
    BASE = "https://api.open-meteo.com/v1/forecast"

    attr_reader :client
    
    def initialize(client=nil)
      @client = client || Http::RubyClient.new
    end

    # Returns the forecast for the given latitude and longitude in a simple array format
    def forecast(latitude, longitude)
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
    end
  end
end
