module RDStation
  class Error
    class Formatter
      def initialize(api_response)
        @api_response = api_response
        @errors = JSON.parse(@api_response.body)['errors']
        raise ArgumentError, "'api_response' does not seem to be an error response." unless @errors
      end

      def to_array
        case error_format.format
        when Format::FLAT_HASH
          from_flat_hash
        when Format::HASH_OF_ARRAYS
          from_hash_of_arrays
        else
          @errors.each_with_object([]) do |error, array_of_errors|
            array_of_errors.push(error.merge(additional_request_info))
          end
        end
      end

      def from_flat_hash
        [@errors.merge(additional_request_info)]
      end

      def from_hash_of_arrays
        @errors.each_with_object([]) do |attribute_error, array_of_errors|
          attribute, errors = attribute_error.first, attribute_error.last
          additional_attributes = { 'path' => "body.#{attribute}" }.merge(additional_request_info)
          errors = errors.map { |e| e.merge(additional_attributes) }
          array_of_errors.push(*errors)
        end
      end

      def error_format
        @error_format ||= Format.new(@errors)
      end

      def additional_request_info
        {
          'headers' => @api_response.headers,
          'status' => @api_response.code
        }
      end

      class Format
        ARRAY_OF_HASHES = 'ARRAY_OF_HASHES'.freeze
        FLAT_HASH = 'FLAT_HASH'.freeze
        HASH_OF_ARRAYS = 'HASH_OF_ARRAYS'.freeze

        def initialize(errors)
          @errors = errors
        end

        def format
          return 'FLAT_HASH' if flat_hash?
          return 'HASH_OF_ARRAYS' if hash_of_arrays?
          'ARRAY_OF_HASHES'
        end

        private

        def flat_hash?
          return unless @errors.is_a?(Hash)
          @errors.key?('error_type')
        end

        def hash_of_arrays?
          @errors.is_a?(Hash) && @errors.values.all? { |error| error.is_a? Array }
        end
      end
    end
  end
end
