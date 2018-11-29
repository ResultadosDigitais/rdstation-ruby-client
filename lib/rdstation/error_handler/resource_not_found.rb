module RDStation
  class ErrorHandler
    class ResourceNotFound
      attr_reader :errors

      ERROR_CODE = 'RESOURCE_NOT_FOUND'.freeze

      def initialize(errors)
        @errors = errors
      end

      def raise_error
        return if resource_not_found_errors.empty?
        raise RDStation::Error::ResourceNotFound, resource_not_found_errors.first
      end

      private

      def resource_not_found_errors
        errors.select { |error| error['error_type'] == ERROR_CODE }
      end
    end
  end
end
