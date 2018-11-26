module RDStation
  class ErrorHandler
    class ExpiredCodeGrant
      attr_reader :errors

      ERROR_CODE = 'EXPIRED_CODE_GRANT'.freeze

      def initialize(errors)
        @errors = errors
      end

      def raise_error
        return if expired_code_errors.empty?
        raise RDStation::Error::ExpiredCodeGrant, expired_code_errors.first
      end

      private

      def expired_code_errors
        errors.select { |error| error['error_type'] == ERROR_CODE }
      end
    end
  end
end
