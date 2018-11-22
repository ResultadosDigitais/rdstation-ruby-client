module RDStation
  class Error
    class Formatter
      def initialize(api_response)
        @api_response = api_response
        @errors = JSON.parse(@api_response.body)['errors']
        raise ArgumentError, "'api_response' does not seem to be an error response." unless @errors
      end

      def to_array
        raise RDStation, 'This is not an error message.' unless @errors

        if flat_errors?
          return [@errors.merge(additional_request_info)]
        elsif hash_of_arrays?
          return @errors.each_with_object([]) do |attribute_error, array_of_errors|
            attribute, errors = attribute_error.first, attribute_error.last
            additional_attributes = { 'path' => "body.#{attribute}" }.merge(additional_request_info)
            errors = errors.map { |e| e.merge(additional_attributes) }
            array_of_errors.push(*errors)
          end
        end

        @errors.each_with_object([]) do |error, array_of_errors|
          array_of_errors.push(error.merge(additional_request_info))
        end
      end

      def flat_errors?
        return unless @errors.is_a?(Hash)
        @errors.key?('error_type')
      end

      def hash_of_arrays?
        @errors.is_a?(Hash) && @errors.values.all? { |error| error.is_a? Array }
      end

      def additional_request_info
        {
          'headers' => @api_response.headers,
          'status' => @api_response.code
        }
      end
    end
  end
end
