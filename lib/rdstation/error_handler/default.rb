module RDStation
  class ErrorHandler
    class Default
      attr_reader :errors

      def initialize(errors)
        @errors = errors
      end

      def raise_error
        raise RDStation::Error::Default, errors.first
      end
    end
  end
end
