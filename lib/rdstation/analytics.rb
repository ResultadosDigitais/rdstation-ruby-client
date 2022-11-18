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
        response = self.class.get(base_url('emails'), headers: authorization.headers, query: query_params)
        ApiResponse.build(response)
      end
    end

    def conversions(query_params={})
      retryable_request(@authorization) do |authorization|
        response = self.class.get(base_url('conversions'), headers: authorization.headers, query: query_params)
        ApiResponse.build(response)
      end
    end

    private

    def base_url(path='')
      "#{RDStation.host}/platform/analytics/#{path}"
    end
  end
end