# encoding: utf-8
module RDStation
  # More info: https://developers.rdstation.com/pt-BR/reference/contacts
  class Fields
    include HTTParty

    BASE_URL = 'https://api.rd.services/platform/contacts/fields'.freeze
    
    def initialize(authorization_header:)
      @authorization_header = authorization_header
    end

    def all
      response = self.class.get(BASE_URL, headers: @authorization_header.to_h)
      ApiResponse.build(response)
    end

  end
end
