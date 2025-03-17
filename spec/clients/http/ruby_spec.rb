require 'rails_helper'

RSpec.describe Http::Ruby do
  context 'when when the HTTP Request is not successful' do
    it 'raises an error' do
      allow(Net::HTTP).to receive(:get_response).and_return(Net::HTTPServerError.new('1.1', 500, 'Internal Server Error'))

      expect {
        subject.get('https://some-website.com')
      }.to raise_error(Http::Error, "HTTP Request failed with code: 500 and message: Internal Server Error")
    end
  end

  context 'response is successful' do
    context'when the response is JSON' do
      let(:response_double) {
        double(
          content_type: 'application/json', 
          body: '{"key":"value"}',
          code: 200,
          message: 'OK'
        )
      }

      it 'returns a parsed json response' do
        # Stub the equality check so it will look like the double is a Net::HTTPSuccess object
        allow(Net::HTTPSuccess).to receive(:===).and_return(true)

        allow(Net::HTTP).to receive(:get_response).and_return(response_double)
        expect(subject.get('https://some-website.com')).to eq({"key"=>"value"})
      end
    end
  end 
end