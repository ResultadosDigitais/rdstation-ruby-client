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

    class ConflictingField < Error; end
    class Default < Error; end
    class ExpiredAccessToken < Error; end
    class ExpiredCodeGrant < Error; end
    class InvalidCredentials < Error; end
    class InvalidEventType < Error; end
    class ResourceNotFound < Error; end
    class Unauthorized < Error; end
  end
end
