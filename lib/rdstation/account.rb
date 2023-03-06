# frozen_string_literal: true

module RDStation
  class Account
    include HTTParty
    include ::RDStation::RetryableRequest

    def initialize(authorization:)
      @authorization = authorization
    end

    def info
      retryable_request(@authorization) do |authorization|
        response = self.class.get(base_url, headers: authorization.headers)
        ApiResponse.build(response)
      end
    end

    private

    def base_url(_path = '')
      "#{RDStation.host}/marketing/account_info"
    end
  end
end
