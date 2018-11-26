module RDStation

  class Error < StandardError
    attr_reader :details

    def initialize(details)
      @details = details
      message = details['error_message']
      raise ArgumentError, 'The details hash must contain an error message' unless message
      super(message)
    end

    class ConflictingField < Error; end
    class Default < Error; end
    class ExpiredAccessToken < Error; end
    class ExpiredCodeGrant < Error; end
    class InvalidCredentials < Error; end
    class ResourceNotFound < Error; end
    class Unauthorized < Error; end
  end
end
