require_relative 'conflicting_field'
require_relative 'invalid_event_type'

module RDStation
  class ErrorHandler
    class BadRequest
      BAD_REQUEST_ERRORS = [
        ErrorHandler::ConflictingField,
        ErrorHandler::InvalidEventType,
      ].freeze

      def initialize(array_of_errors)
        @array_of_errors = array_of_errors
      end

      def raise_error
        error_classes.each(&:raise_error)
        raise RDStation::Error::BadRequest, @array_of_errors.first
      end

      private

      def error_classes
        BAD_REQUEST_ERRORS.map do |error|
          error.new(@array_of_errors)
        end
      end
    end
  end
end
