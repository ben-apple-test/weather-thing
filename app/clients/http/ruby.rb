module Http
  class Error < StandardError; end

  class Ruby
    def get(url, params = {}, headers = {})
      uri = URI(url)
      uri.query = URI.encode_www_form(params) unless params.empty?

      response = Net::HTTP.get_response(uri, headers)
      handle_response(response)
    rescue Timeout::Error, SocketError, Errno::ECONNREFUSED => e
      raise Error, "Connection failed: #{e.message}"
    end

    private

    def handle_response(response)
      case response
      when Net::HTTPSuccess
        parse_response(response)
      else
        raise Error, "HTTP Request failed with code: #{response.code} and message: #{response.message}"
      end
    end

    def parse_response(response)
      return response.body unless json_response?(response)
      JSON.parse(response.body)
    rescue JSON::ParserError
      raise Error, "Invalid JSON response"
    end

    def json_response?(response)
      response.content_type == "application/json"
    end
  end
end
