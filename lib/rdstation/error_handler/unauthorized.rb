require_relative 'expired_access_token'
require_relative 'expired_code_grant'
require_relative 'invalid_credentials'
require_relative 'invalid_refresh_token'

module RDStation
  class ErrorHandler
    class Unauthorized
      UNAUTHORIZED_ERRORS = [
        ErrorHandler::ExpiredAccessToken,
        ErrorHandler::ExpiredCodeGrant,
        ErrorHandler::InvalidCredentials,
        ErrorHandler::InvalidRefreshToken,
      ].freeze

      def initialize(array_of_errors)
        @array_of_errors = array_of_errors
      end

      def raise_error
        error_classes.each(&:raise_error)
        raise RDStation::Error::Unauthorized, @array_of_errors.first
      end

      private

      def error_classes
        UNAUTHORIZED_ERRORS.map do |error|
          error.new(@array_of_errors)
        end
      end
    end
  end
end
