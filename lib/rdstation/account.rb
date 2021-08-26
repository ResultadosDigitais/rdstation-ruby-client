# encoding: utf-8
module RDStation
  # More info: https://developers.rdstation.com/pt-BR/reference/fields
  class Account
    include HTTParty
    include ::RDStation::RetryableRequest

    BASE_URL = 'https://api.rd.services/marketing/account_info'.freeze

    def initialize(authorization:)
      @authorization = authorization
    end

    def info
      retryable_request(@authorization) do |authorization|
        response = self.class.get(BASE_URL, headers: authorization.headers)
        ApiResponse.build(response)
      end
    end
  end
end
