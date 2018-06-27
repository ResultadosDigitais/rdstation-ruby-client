module RDStation
  class ErrorHandler
    class Unauthorized
      attr_reader :api_response, :response_body

      ERROR_CODE = 'UNAUTHORIZED'.freeze
      EXCEPTION_CLASS = RDStation::Error::Unauthorized

      def initialize(api_response)
        @api_response = api_response
        @response_body = JSON.parse(api_response.body)
      end

      def raise_error
        return unless unauthorized?
        raise EXCEPTION_CLASS.new(response_body['error_message'], api_response)
      end

      private

      def unauthorized?
        @response_body['error_type'] == ERROR_CODE
      end
    end
  end
end
