require 'rails_helper'

RSpec.describe FetchWeatherForecast do
  let(:latitude) { 40.7128 }
  let(:longitude) { -74.0060 }
  let(:zip_code) { 90731 }
  let(:forecast_service) { instance_double(Weather::OpenMeteo) }
  let(:forecast_data) do
    [
      {
        date: '2023-10-01',
        max_temp: 25,
        min_temp: 15,
        precipitation: 5
      }
    ]
  end

  before do
    allow(Weather::OpenMeteo).to receive(:new).and_return(forecast_service)
    allow(forecast_service).to receive(:forecast).and_return(forecast_data)
    allow(Geocoder).to receive(:coordinates).and_return([latitude, longitude])
  end

  context 'when forecast is cached' do
    it 'returns cached forecast' do
      allow(Rails.cache).to receive(:read).and_return(forecast_data)
      result = described_class.call(zip_code: zip_code)
      
      expect(result).to be_success
      expect(result.result).to eq({
        is_cached: true,
        zip_code: zip_code,
        forecast: forecast_data
      })
    end
  end

  context 'when forecast is not cached' do
    it 'fetches and caches new forecast' do
      allow(Rails.cache).to receive(:read).and_return(nil)
      allow(Rails.cache).to receive(:write)

      result = described_class.call(zip_code: zip_code)
      
      expect(result).to be_success
      expect(result.result).to eq({
        is_cached: false,
        zip_code: zip_code,
        forecast: forecast_data
      })
      
      expect(Rails.cache).to have_received(:write).with("forecast_#{zip_code}", forecast_data, expires_in: described_class::CACHE_TTL)
    end
  end

  context 'when geocoding fails' do
    before do
      allow(Geocoder).to receive(:coordinates).with(zip_code).and_return(nil)
    end

    it 'fails with error message' do
      result = described_class.call(zip_code: zip_code)
      
      expect(result).to be_failure
      expect(result.error).to eq('Unable to geocode zip code')
    end
  end

  context 'when forecast service fails' do
    before do
      allow(forecast_service).to receive(:forecast).and_raise(StandardError.new('API Error'))
    end

    it 'fails with error message' do
      result = described_class.call(zip_code: zip_code)
      
      expect(result).to be_failure
      expect(result.error).to eq('API Error')
    end
  end
end
