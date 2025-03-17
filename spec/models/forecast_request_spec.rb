require 'rails_helper'

RSpec.describe ForecastRequest, type: :model do
  describe 'validations' do
    let(:valid_zip_code) { ZipCode.create!(code: '90210') }
    let(:attributes) do
      {
        street: '123 Main St',
        city: 'Boston',
        state: 'Massachusetts',
        zip_code: valid_zip_code.code
      }
    end

    subject { ForecastRequest.new(attributes) }

    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }

    it { should validate_presence_of(:state) }

    it { should validate_presence_of(:zip_code) }
    it { should validate_length_of(:zip_code).is_equal_to(5) }
    it { should validate_numericality_of(:zip_code).only_integer }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    context 'invalid or unknown zip code' do
      let(:attributes) do 
        {
          street: '123 Main St',
          city: 'Boston',
          state: 'MA',
          zip_code: '00000' # Assuming this is an unknown zip code
        }
      end

      it 'is invalid with unknown zip code' do
        expect(subject).not_to be_valid
        expect(subject.errors[:zip_code]).to include('is not a known zip code')
      end
    end

    # Add test for state format
    it 'should not allow numbers in state' do
      subject.state = '12'
      expect(subject).not_to be_valid
      expect(subject.errors[:state]).to include('is not a valid state')
    end

    # Add test for malformed zip code
    it 'should not allow letters in zip code' do
      subject.zip_code = '1234A'
      expect(subject).not_to be_valid
      expect(subject.errors[:zip_code]).to include('is not a number')
    end
  end

  describe '#attributes' do
    it 'returns a hash of attributes' do
      request = ForecastRequest.new(
        street: '123 Main St',
        city: 'Boston',
        state: 'MA',
        zip_code: '02108'
      )

      expect(request.attributes).to eq({
        street: '123 Main St',
        city: 'Boston',
        state: 'MA',
        zip_code: '02108'
      })
    end
  end
end
