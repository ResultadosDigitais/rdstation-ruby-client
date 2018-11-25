module RDStation
  class ErrorHandler
    class ConflictingField
      attr_reader :errors

      ERROR_CODE = 'CONFLICTING_FIELD'.freeze

      def initialize(errors)
        @errors = errors
      end

      def raise_error
        return if conflicting_field_errors.empty?
        raise RDStation::Error::ConflictingField, conflicting_field_errors.first
      end

      private

      def conflicting_field_errors
        errors.select { |error| error['error_type'] == ERROR_CODE }
      end
    end
  end
end
