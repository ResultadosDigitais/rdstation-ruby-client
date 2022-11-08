# frozen_string_literal: true

module RDStation
  class Analytics
    include HTTParty
    include ::RDStation::RetryableRequest

    def initialize(authorization:)
      @authorization = authorization
    end

    def email_marketing(query_params={})
      retryable_request(@authorization) do |authorization|
        response = self.class.get(base_url, headers: authorization.headers, query: query_params)
        ApiResponse.build(response)
      end
    end

    private

    def base_url
      "#{RDStation.host}/platform/analytics/emails"
    end
  end
end
