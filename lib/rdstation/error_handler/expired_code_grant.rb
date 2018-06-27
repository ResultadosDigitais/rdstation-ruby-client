module RDStation
  class ErrorHandler
    class ExpiredCodeGrant
      attr_reader :api_response, :response_headers, :errors

      ERROR_CODE = 'EXPIRED_CODE_GRANT'.freeze
      EXCEPTION_CLASS = RDStation::Error::ExpiredCodeGrant

      def initialize(api_response)
        @api_response = api_response
        @errors = JSON.parse(api_response.body)['errors']
        @response_headers = api_response.headers
      end

      def raise_error
        return unless expired_code?
        raise EXCEPTION_CLASS.new(error['error_message'], api_response)
      end

      private

      def error
        @errors.first
      end

      def expired_code?
        error['error_type'] == ERROR_CODE
      end
    end
  end
end
