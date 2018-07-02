module RDStation
  class ErrorHandler
    class Unauthorized
      attr_reader :api_response, :response_body, :error

      ERROR_CODE = 'UNAUTHORIZED'.freeze
      EXCEPTION_CLASS = RDStation::Error::Unauthorized

      def initialize(api_response)
        @api_response = api_response
        @error = JSON.parse(api_response.body)['errors']
      end

      def raise_error
        return unless unauthorized?
        raise EXCEPTION_CLASS.new(error['error_message'], api_response)
      end

      private

      def unauthorized?
        error['error_type'] == ERROR_CODE
      end
    end
  end
end
