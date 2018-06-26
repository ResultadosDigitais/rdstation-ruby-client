module RDStation

  class Error < StandardError
    attr_reader :http_status, :headers, :body

    def initialize(message, request_error)
      @http_status = request_error.code
      @headers = request_error.headers
      @body = JSON.parse(request_error.body)
      super(message)
    end

    class ExpiredCodeGrant < Error; end
    class InvalidCredentials < Error; end
  end
end
