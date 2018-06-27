module RDStation

  class Error < StandardError
    attr_reader :http_status, :headers, :body

    def initialize(message, api_response_error)
      @http_status = api_response_error.code
      @headers = api_response_error.headers
      @body = JSON.parse(api_response_error.body)
      super(message)
    end

    class ExpiredAccessToken < Error; end
    class ExpiredCodeGrant < Error; end
    class InvalidCredentials < Error; end
    class ResourceNotFound < Error; end
    class Unauthorized < Error; end
  end
end
