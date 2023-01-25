# frozen_string_literal: true

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
        when RDStation::Error::Format::SINGLE_HASH
          return from_single_hash
        when RDStation::Error::Format::FLAT_HASH
          return from_flat_hash
        when RDStation::Error::Format::HASH_OF_ARRAYS
          return from_hash_of_arrays
        when RDStation::Error::Format::HASH_OF_HASHES
          return from_hash_of_hashes
        when RDStation::Error::Format::HASH_OF_MULTIPLE_TYPES
          return from_hash_of_multiple_types
        end

        errors
      end

      def from_single_hash
        error_hash = @error_response.dup
        error_message = error_hash.delete('error') || error_hash.delete('message')

        [
          {
            'error_type' => 'TOO_MANY_REQUESTS',
            'error_message' => error_message
          }
        ]
      end

      def from_flat_hash
        [errors]
      end

      def from_hash_of_multiple_types
        array_of_errors = []
        errors.each do |attribute_name, errors|
          if errors.is_a? Array
            result = build_error_from_array(attribute_name, errors)
          end
          if errors.is_a? Hash
            result = build_error_from_multilingual_hash(attribute_name, errors)
          end
          array_of_errors.push(*result)
        end

        array_of_errors
      end

      def from_hash_of_hashes
        array_of_errors = []
        errors.each do |attribute_name, errors|
          result = build_error_from_multilingual_hash(attribute_name, errors)
          array_of_errors.push(*result)
        end

        array_of_errors
      end

      def error_format
        @error_format ||= RDStation::Error::Format.new(errors)
      end

      def errors
        @errors ||= @error_response.fetch('errors', @error_response)
      end

      private

      def build_error_from_array(attribute_name, attribute_errors)
        path = { 'path' => "body.#{attribute_name}" }
        attribute_errors.map { |error| error.merge(path) }
      end

      def build_error_from_multilingual_hash(attribute_name, errors_by_language)
        array_of_errors = []
        errors_by_language.each do |language, errors|
          result = build_error_from_array("#{attribute_name}.#{language}", errors)
          array_of_errors.push(*result)
        end
        array_of_errors
      end

      def from_hash_of_arrays
        errors.each_with_object([]) do |errors, array_of_errors|
          attribute_name = errors.first
          attribute_errors = errors.last
          errors = build_error_from_array(attribute_name, attribute_errors)
          array_of_errors.push(*errors)
        end
      end
    end
  end
end
