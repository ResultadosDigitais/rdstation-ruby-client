# frozen_string_literal: true

module RDStation
  class Error
    class Format
      FLAT_HASH = 'FLAT_HASH'
      HASH_OF_ARRAYS = 'HASH_OF_ARRAYS'
      ARRAY_OF_HASHES = 'ARRAY_OF_HASHES'
      HASH_OF_MULTIPLE_TYPES = 'HASH_OF_MULTIPLE_TYPES'
      HASH_OF_HASHES = 'HASH_OF_HASHES'
      SINGLE_HASH = 'SINGLE_HASH'

      def initialize(errors)
        @errors = errors
      end

      def format
        return FLAT_HASH if flat_hash?
        return SINGLE_HASH if single_hash?
        return HASH_OF_ARRAYS if hash_of_arrays?
        return HASH_OF_HASHES if hash_of_hashes?
        return HASH_OF_MULTIPLE_TYPES if hash_of_multiple_types?

        ARRAY_OF_HASHES
      end

      private

      def single_hash?
        return unless @errors.is_a?(Hash)

        @errors.key?('error')
      end

      def flat_hash?
        return unless @errors.is_a?(Hash)

        @errors.key?('error_type')
      end

      def hash_of_arrays?
        @errors.is_a?(Hash) && @errors.values.all? { |error| error.is_a? Array }
      end

      def hash_of_hashes?
        @errors.is_a?(Hash) && @errors.values.all? { |error| error.is_a? Hash }
      end

      def hash_of_multiple_types?
        @errors.is_a?(Hash) &&
          @errors.values.any? { |error| error.is_a? Hash } &&
          @errors.values.any? { |error| error.is_a? Array }
      end
    end
  end
end
