module RDStation
  class ErrorHandler
    class ExpiredCodeGrant
      attr_reader :api_response, :response_headers, :response_body

      ERROR_CODE = 'EXPIRED_CODE_GRANT'.freeze
      EXCEPTION_CLASS = RDStation::Error::ExpiredCodeGrant

      def initialize(api_response)
        @api_response = api_response
        @response_body = JSON.parse(api_response.body)
        @response_headers = api_response.headers
      end

      def raise_error
        return unless expired_code?
        raise EXCEPTION_CLASS.new(response_body['error_message'], api_response)
      end

      private

      def expired_code?
        @response_body['error_type'] == ERROR_CODE
      end
    end
  end
end
