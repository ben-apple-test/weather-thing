require 'rails_helper'

RSpec.describe FetchWeatherForecast do
  let(:zip_code) { "12345" }
  let(:coords) { [ 42.0, -71.0 ] }
  let(:weather_service) { instance_double(Weather::OpenMeteo) }
  let(:forecast_data) { { "temp" => 72 } }
  let(:temperature_data) { 75.5 }

  subject(:context) { described_class.call(zip_code: zip_code) }

  before do
    allow(Weather::OpenMeteo).to receive(:new).and_return(weather_service)
    allow(Geocoder).to receive(:coordinates).with(zip_code).and_return(coords)
    allow(weather_service).to receive(:forecast).and_return(forecast_data)
    allow(weather_service).to receive(:current_temperature).and_return(temperature_data)
  end

  context "when data is not cached" do
    before do
      allow(Rails.cache).to receive(:read).with("forecast_#{zip_code}").and_return(nil)
      allow(Rails.cache).to receive(:read).with("temperature_#{zip_code}").and_return(nil)
    end

    it "fetches fresh data" do
      expect(context).to be_success
      expect(context.result).to include(
        is_cached: false,
        zip_code: zip_code,
        forecast: forecast_data,
        current_temperature: temperature_data
      )
    end
  end

  context "when data is cached" do
    before do
      allow(Rails.cache).to receive(:read).with("forecast_#{zip_code}").and_return(forecast_data)
      allow(Rails.cache).to receive(:read).with("temperature_#{zip_code}").and_return(temperature_data)
    end

    it "returns cached data" do
      expect(weather_service).not_to receive(:forecast)
      expect(weather_service).not_to receive(:current_temperature)

      expect(context).to be_success
      expect(context.result).to include(
        is_cached: true,
        forecast: forecast_data,
        current_temperature: temperature_data
      )
    end
  end

  context "when geocoding fails" do
    before { allow(Geocoder).to receive(:coordinates).and_return(nil) }

    it "fails with an error message" do
      expect(context).to be_failure
      expect(context.error).to include("Unable to geocode zip code")
    end
  end

  context "when weather service fails" do
    before { allow(weather_service).to receive(:forecast).and_raise(StandardError, "API Error") }

    it "fails with an error message" do
      expect(context).to be_failure
      expect(context.error).to include("Failed to fetch forecast")
    end
  end
end
