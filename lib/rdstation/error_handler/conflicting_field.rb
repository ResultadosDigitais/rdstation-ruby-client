module RDStation
  class ErrorHandler
    class ConflictingField
      attr_reader :errors

      ERROR_CODE = 'CONFLICTING_FIELD'.freeze
      EXCEPTION_CLASS = RDStation::Error::ConflictingField

      def initialize(errors)
        @errors = errors
      end

      def raise_error
        return if conflicting_field_errors.empty?
        raise EXCEPTION_CLASS.new(error['error_message'], api_response)
      end

      private

      def conflicting_field_errors
        errors.select { |error| error['error_type'] == ERROR_CODE }
      end
    end
  end
end
