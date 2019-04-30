module RDStation
  class Error < StandardError
    attr_reader :details, :http_status, :headers, :body

    def initialize(details)
      @details = details
      message = details['error_message']
      raise ArgumentError, 'The details hash must contain an error message' unless message

      # Those three arguments are kept only for compatibility reasons.
      # They aren't needed since we can get them directly in the details hash.
      # Consider removing them when update the major version.
      @http_status = details['http_status']
      @headers = details['headers']
      @body = details['body']

      super(message)
    end

    class BadRequest < Error; end
    class Unauthorized < Error; end
    class Forbidden < Error; end
    class NotFound < Error; end
    class MethodNotAllowed < Error; end
    class NotAcceptable < Error; end
    class Conflict < Error; end
    class UnsupportedMediaType < Error; end
    class UnprocessableEntity < Error; end
    class InternalServerError < Error; end
    class NotImplemented < Error; end
    class BadGateway < Error; end
    class ServiceUnavailable < Error; end
    class ServerError < Error; end

    # 400 - Bad Request
    class ConflictingField < Error; end
    class InvalidEventType < Error; end

    # 401 - Unauthorized
    class ExpiredAccessToken < Error; end
    class ExpiredCodeGrant < Error; end
    class InvalidCredentials < Error; end
  end
end
