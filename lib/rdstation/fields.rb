# encoding: utf-8
module RDStation
  # More info: https://developers.rdstation.com/pt-BR/reference/contacts
  class Fields
    include HTTParty

    BASE_URL = 'https://api.rd.services/platform/contacts/fields'.freeze

    def initialize(auth_token)
      @auth_token = auth_token
    end

    def all
      response = self.class.get(BASE_URL, headers: required_headers)
      ApiResponse.build(response)
    end

    private

    def required_headers
      { "Authorization" => "Bearer #{@auth_token}", "Content-Type" => "application/json" }
    end
  end
end
