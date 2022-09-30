# frozen_string_literal: true

module RDStation
  # More info: https://developers.rdstation.com/pt-BR/reference/fields
  class Fields
    include HTTParty
    include ::RDStation::RetryableRequest

    def initialize(authorization:)
      @authorization = authorization
    end

    def all
      retryable_request(@authorization) do |authorization|
        response = self.class.get(base_url, headers: authorization.headers)
        ApiResponse.build(response)
      end
    end

    def create(payload)
      retryable_request(@authorization) do |authorization|
        response = self.class.post(base_url, headers: authorization.headers, body: payload.to_json)
        ApiResponse.build(response)
      end
    end

    def update(uuid, payload)
      retryable_request(@authorization) do |authorization|
        response = self.class.patch(base_url(uuid), headers: authorization.headers, body: payload.to_json)
        ApiResponse.build(response)
      end
    end

    def delete(uuid)
      retryable_request(@authorization) do |authorization|
        response = self.class.delete(base_url(uuid), headers: authorization.headers)
        ApiResponse.build(response)
      end
    end

    private

    def base_url(path = '')
      "#{RDStation.host}/platform/contacts/fields/#{path}"
    end
  end
end
