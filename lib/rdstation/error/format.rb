module RDStation
  class Error
    class Format
      FLAT_HASH = 'FLAT_HASH'.freeze
      HASH_OF_ARRAYS = 'HASH_OF_ARRAYS'.freeze
      ARRAY_OF_HASHES = 'ARRAY_OF_HASHES'.freeze

      def initialize(errors)
        @errors = errors
      end

      def format
        return FLAT_HASH if flat_hash?
        return HASH_OF_ARRAYS if hash_of_arrays?
        ARRAY_OF_HASHES
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
