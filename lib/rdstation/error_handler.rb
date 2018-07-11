require_relative 'error_handler/conflicting_field'
require_relative 'error_handler/default'
require_relative 'error_handler/expired_access_token'
require_relative 'error_handler/expired_code_grant'
require_relative 'error_handler/invalid_credentials'
require_relative 'error_handler/resource_not_found'
require_relative 'error_handler/unauthorized'

module RDStation
  class ErrorHandler
    ERROR_TYPES = [
      ErrorHandler::ConflictingField,
      ErrorHandler::ExpiredAccessToken,
      ErrorHandler::ExpiredCodeGrant,
      ErrorHandler::InvalidCredentials,
      ErrorHandler::ResourceNotFound,
      ErrorHandler::Unauthorized,
      ErrorHandler::Default
    ].freeze

    def initialize(response)
      @response = response
    end

    def raise_errors
      errors.each(&:raise_error)
      # Raise only the exception message when the error is not recognized
      unrecognized_error = @response['errors']
      raise unrecognized_error['error_message']
    end

    private

    def errors
      ERROR_TYPES.map { |error| error.new(@response) }
    end
  end
end
