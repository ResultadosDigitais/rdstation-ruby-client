# frozen_string_literal: true

module RDStation
  class Events
    include HTTParty
    include ::RDStation::RetryableRequest

    def initialize(authorization:)
      @authorization = authorization
    end

    def create(payload)
      retryable_request(@authorization) do |authorization|
        response = self.class.post(base_url, headers: authorization.headers, body: payload.to_json)
        ApiResponse.build(response)
      end
    end

    private

    def base_url
      "#{RDStation.host}/platform/events"
    end
  end
end
