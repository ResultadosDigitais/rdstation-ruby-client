module RDStation
  class ErrorHandler
    class ResourceNotFound
      attr_reader :api_response, :response_body

      ERROR_CODE = 'RESOURCE_NOT_FOUND'.freeze
      EXCEPTION_CLASS = RDStation::Error::ResourceNotFound

      def initialize(api_response)
        @api_response = api_response
        @response_body = JSON.parse(api_response.body)
      end

      def raise_error
        return unless resource_not_found?
        raise EXCEPTION_CLASS.new(response_body['error_message'], api_response)
      end

      private

      def resource_not_found?
        @response_body['error_type'] == ERROR_CODE
      end
    end
  end
end
