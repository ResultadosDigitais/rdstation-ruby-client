# frozen_string_literal: true

module RDStation
  class LandingPages
    include HTTParty
    include ::RDStation::RetryableRequest

    def initialize(authorization:)
      @authorization = authorization
    end

    def all(query_params={})
      retryable_request(@authorization) do |authorization|
        response = self.class.get(base_url, headers: authorization.headers, query: query_params)
        ApiResponse.build_with_headers(response)
      end
    end

    private

    def base_url(path='')
      "#{RDStation.host}/platform/landing_pages/#{path}"
    end
  end
end
