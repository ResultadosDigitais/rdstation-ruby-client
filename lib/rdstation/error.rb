module RDStation

  ERROR = {
    'EXPIRED_CODE_GRANT' => Error::ExpiredCodeGrant,
    'INVALID_CREDENTIALS' => Error::InvalidCredentials
  }.freeze

  class Error < StandardError
    attr_reader :http_status, :headers, :body

    def initialize(error)
      @http_status = error.code
      @headers = error.headers
      @body = JSON.parse(error.body)
      @type = error['error_type']
    end

    class ExpiredCodeGrant < Error; end
    class InvalidCredentials < Error; end
  end
end
