require_relative './format'

module RDStation
  class Error
    class Formatter
      def initialize(error_response)
        @error_response = error_response
      end

      def to_array
        return @error_response unless @error_response.is_a?(Hash)

        case error_format.format
        when RDStation::Error::Format::FLAT_HASH
          return from_flat_hash
        when RDStation::Error::Format::HASH_OF_ARRAYS
          return from_hash_of_arrays
        end

        errors
      end

      def from_flat_hash
        [errors]
      end

      def from_hash_of_arrays
        errors.each_with_object([]) do |errors, array_of_errors|
          attribute_name = errors.first
          attribute_errors = errors.last
          path = { 'path' => "body.#{attribute_name}" }
          errors = attribute_errors.map { |error| error.merge(path) }
          array_of_errors.push(*errors)
        end
      end

      def error_format
        @error_format ||= RDStation::Error::Format.new(errors)
      end

      def errors
        @errors ||= @error_response['errors']
      end
    end
  end
end
