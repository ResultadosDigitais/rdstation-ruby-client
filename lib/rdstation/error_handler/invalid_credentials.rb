module RDStation
  class ErrorHandler
    class InvalidCredentials
      attr_reader :errors

      ERROR_CODE = 'ACCESS_DENIED'.freeze

      def initialize(errors)
        @errors = errors
      end

      def raise_error
        return if invalid_credentials_error.empty?
        raise RDStation::Error::InvalidCredentials, invalid_credentials_error.first
      end

      private

      def invalid_credentials_error
        errors.select { |error| error['error_type'] == ERROR_CODE }
      end
    end
  end
end
