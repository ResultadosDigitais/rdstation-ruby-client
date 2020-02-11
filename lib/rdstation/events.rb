module RDStation
  class Events
    include HTTParty
    include ::RDStation::RetryableRequest

    EVENTS_ENDPOINT = 'https://api.rd.services/platform/events'.freeze

    def initialize(authorization:)
      @authorization = authorization
    end

    def create(payload)
      retryable_request(@authorization) do |authorization|
        response = self.class.post(EVENTS_ENDPOINT, headers: authorization.headers, body: payload.to_json)
        ApiResponse.build(response)
      end
    end
  end
end
