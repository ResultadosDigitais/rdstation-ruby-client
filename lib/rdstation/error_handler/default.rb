module RDStation
  class ErrorHandler
    class Default
      attr_reader :api_response
      EXCEPTION_CLASS = RDStation::Error::Default

      def initialize(api_response)
        @api_response = api_response
      end

      def raise_error
        raise RDStation::Error::Default.new(
          'An unrecognized error has occurred.',
          api_response
        )
      end
    end
  end
end
