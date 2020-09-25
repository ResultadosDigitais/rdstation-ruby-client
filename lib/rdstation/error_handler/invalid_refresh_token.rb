module RDStation
  class ErrorHandler
    class InvalidRefreshToken
      attr_reader :errors

      ERROR_CODE = 'INVALID_REFRESH_TOKEN'.freeze

      def initialize(errors)
        @errors = errors
      end

      def raise_error
        return if invalid_refresh_token_error.empty?
        raise RDStation::Error::InvalidRefreshToken, invalid_refresh_token_error
      end

      private

      def invalid_refresh_token_error
        errors.find { |error| error['error_type'] == ERROR_CODE }
      end
    end
  end
end
