# frozen_string_literal: true

module RDStation
  class Emails
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

    def by_id(id)
      retryable_request(@authorization) do |authorization|
        response = self.class.get(base_url(id), headers: authorization.headers)
        ApiResponse.build_with_headers(response)
      end
    end

    private

    def base_url(path='')
      "#{RDStation.host}/platform/emails/#{path}"
    end
  end
end
