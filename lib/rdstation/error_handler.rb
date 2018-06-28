require_relative 'error_handler/expired_access_token'
require_relative 'error_handler/expired_code_grant'
require_relative 'error_handler/invalid_credentials'
require_relative 'error_handler/resource_not_found'
require_relative 'error_handler/unauthorized'

module RDStation
  class ErrorHandler
    ERROR_TYPES = [
      ErrorHandler::ExpiredAccessToken,
      ErrorHandler::ExpiredCodeGrant,
      ErrorHandler::InvalidCredentials,
      ErrorHandler::ResourceNotFound,
      ErrorHandler::Unauthorized
    ].freeze

    def initialize(response)
      @response = response
    end

    def raise_errors
      errors.each(&:raise_error)
    end

    private

    def errors
      ERROR_TYPES.map { |error| error.new(@response) }
    end
  end
end
