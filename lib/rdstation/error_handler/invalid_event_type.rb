module RDStation
  class ErrorHandler
    class InvalidEventType
      attr_reader :errors

      ERROR_CODE = 'INVALID_OPTION'.freeze
      PATH = '$.event_type'.freeze

      def initialize(errors)
        @errors = errors
      end

      def raise_error
        return if invalid_event_type_error.empty?
        raise RDStation::Error::InvalidEventType, invalid_event_type_error.first
      end

      private

      def invalid_event_type_error
        errors.select do |error|
          error.values_at('error_type', 'path') == [ERROR_CODE, PATH]
        end
      end
    end
  end
end
