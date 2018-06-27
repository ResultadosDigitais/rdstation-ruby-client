module RDStation
  class ErrorHandler
    class ExpiredAccessToken
      attr_reader :api_response, :response_headers, :response_body

      EXCEPTION_CLASS = RDStation::Error::ExpiredAccessToken

      def initialize(api_response)
        @api_response = api_response
        @response_body = JSON.parse(api_response.body)
        @response_headers = api_response.headers
      end

      def raise_error
        return unless expired_token?
        raise EXCEPTION_CLASS.new(response_body['error_message'], api_response)
      end

      private

      def expired_token?
        auth_header = response_headers['x-amzn-remapped-www-authenticate'] ||
                      response_headers['www-authenticate']

        return unless auth_header
        auth_header.include?('error="expired_token"')
      end
    end
  end
end
