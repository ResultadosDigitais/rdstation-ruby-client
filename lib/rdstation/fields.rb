# encoding: utf-8
module RDStation
  # More info: https://developers.rdstation.com/pt-BR/reference/fields
  class Fields
    include HTTParty
    include ::RDStation::RetryableRequest

    BASE_URL = 'https://api.rd.services/platform/contacts/fields'.freeze

    def initialize(authorization:)
      @authorization = authorization
    end

    def all
      retryable_request(@authorization) do |authorization|
        response = self.class.get(BASE_URL, headers: authorization.headers)
        ApiResponse.build(response)
      end
      end

    def create(payload)
      retryable_request(@authorization) do |authorization|
        response = self.class.post(BASE_URL, headers: authorization.headers, body: payload.to_json)
        ApiResponse.build(response)
      end
    end

  end
end
