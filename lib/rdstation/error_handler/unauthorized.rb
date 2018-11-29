module RDStation
  class ErrorHandler
    class Unauthorized
      attr_reader :errors

      ERROR_CODE = 'UNAUTHORIZED'.freeze

      def initialize(errors)
        @errors = errors
      end

      def raise_error
        return if unauthorized_errors.empty?
        raise RDStation::Error::Unauthorized, unauthorized_errors.first
      end

      private

      def unauthorized_errors
        errors.select { |error| error['error_type'] == ERROR_CODE }
      end
    end
  end
end
