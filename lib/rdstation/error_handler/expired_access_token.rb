module RDStation
  class ErrorHandler
    class ExpiredAccessToken
      attr_reader :errors

      EXPIRED_TOKEN_ERROR = 'error="expired_token"'.freeze

      def initialize(errors)
        @errors = errors
      end

      def raise_error
        return if expired_token_errors.empty?
        raise RDStation::Error::ExpiredAccessToken, expired_token_errors.first
      end

      private

      def expired_token_errors
        errors.select do |error|
          error_header = error['headers']
          next unless error_header
          find_expired_token_error(error_header)
        end
      end

      def find_expired_token_error(error_header)
        auth_header = error_header['x-amzn-remapped-www-authenticate'] || error_header['www-authenticate']
        return unless auth_header
        auth_header.include?(EXPIRED_TOKEN_ERROR)
      end
    end
  end
end
