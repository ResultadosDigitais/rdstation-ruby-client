module RDStation
  class Errors
    ERROR_TYPES = [
      RDStation::ErrorHandler::ExpiredAccessToken,
      RDStation::ErrorHandler::ExpiredCodeGrant,
      RDStation::ErrorHandler::InvalidCredentials,
      RDStation::ErrorHandler::ResourceNotFound,
      RDStation::ErrorHandler::Unauthorized
    ].freeze

    def initialize(response)
      @response = response
      register
    end

    def register
      errors.each do |error|
        error_handler.register_handler(error)
      end
    end

    def raise_errors
      error_handler.handlers.each(&:raise_error)
    end

    def errors
      ERROR_TYPES.map { |error| error.new(@response) }
    end

    def error_handler
      @error_handler ||= RDStation::ErrorHandler.new
    end
  end
end
