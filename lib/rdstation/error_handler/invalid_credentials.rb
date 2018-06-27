module RDStation
  class ErrorHandler
    class InvalidCredentials
      attr_reader :api_response, :response_body

      ERROR_CODE = 'ACCESS_DENIED'.freeze
      EXCEPTION_CLASS = RDStation::Error::InvalidCredentials

      def initialize(api_response)
        @api_response = api_response
        @response_body = JSON.parse(api_response.body)
      end

      def raise_error
        return unless credentials_errors?
        raise EXCEPTION_CLASS.new(response_body['error_message'], api_response)
      end

      private

      def credentials_errors?
        @response_body['error_type'] == ERROR_CODE
      end
    end
  end
end
