require 'rails_helper'

RSpec.describe Weather::OpenMeteo do
  let(:client) { instance_double(Http::Ruby) }
  let(:forecast_service) { described_class.new(client) }

  context 'getting the forecast' do
    let(:forecast_response) { file_fixture('open_meteo/forecast_response.json') }

    it 'returns a formatted forecast in the format of an array' do
      allow(client).to receive(:get).and_return(JSON.parse(forecast_response.read))

      forecast = forecast_service.forecast(52.52, 13.41)

      # Check shape of returned data
      expect(forecast).to be_an(Array)
      expect(forecast.length).to eq(7)
      expect(forecast.first).to include(:date, :max_temp, :min_temp, :precipitation)

      # Check values of returned data against the fixture data
      expect(forecast.first[:date]).to eq('2025-03-17')
      expect(forecast.first[:max_temp]).to eq(1.6)
      expect(forecast.first[:min_temp]).to eq(-3.6)
      expect(forecast.first[:precipitation]).to eq(0.3)
    end
  end

  context 'with invalid coordinates' do
    it 'raises an error for invalid latitude' do
      expect { forecast_service.forecast(91, 0) }.to raise_error(ArgumentError, "Invalid latitude")
    end

    it 'raises an error for invalid longitude' do
      expect { forecast_service.forecast(0, 181) }.to raise_error(ArgumentError, "Invalid longitude")
    end
  end

  context 'when the API request fails' do
    it 'handles the error gracefully' do
      allow(client).to receive(:get).and_raise(Http::Error.new("API unavailable"))
      expect { forecast_service.forecast(0, 0) }.to raise_error(/Weather forecast failed/)
    end
  end
end
