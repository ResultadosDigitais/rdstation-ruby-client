module RDStation
  class ErrorHandler
    class ConflictingField
      attr_reader :api_response, :response_body, :error

      ERROR_CODE = 'CONFLICTING_FIELD'.freeze
      EXCEPTION_CLASS = RDStation::Error::ConflictingField

      def initialize(api_response)
        @api_response = api_response
        @error = JSON.parse(api_response.body)['errors']
      end

      def raise_error
        return unless conflicting_field?
        raise EXCEPTION_CLASS.new(error['error_message'], api_response)
      end

      private

      def conflicting_field?
        error['error_type'] == ERROR_CODE
      end
    end
  end
end
