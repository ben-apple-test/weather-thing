module Http
  # This http client uses the Ruby standard library to make HTTP requests
  class RubyClient
    def get(url, params = {}, headers = {})
      uri = URI(url)
      uri.query = URI.encode_www_form(params) unless params.empty?

      response = Net::HTTP.get_response(uri, headers)
      handle_response(response)
    end

    private

    # Handle different types of HTTP responses and parse the body if its json
    def handle_response(response)
      case response
      when Net::HTTPSuccess
        json_response?(response) ? JSON.parse(response.body) : response.body
      else
        raise "HTTP Request failed with code: #{response.code} and message: #{response.message}"
      end
    end

    def json_response?(response)
      response.content_type == 'application/json'
    end
  end
end