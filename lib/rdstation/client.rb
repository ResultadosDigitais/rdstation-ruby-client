module RDStation
  class Client
    include HTTParty
    base_uri "https://www.rdstation.com.br"

    def initialize(token)
      @token = token
    end

    def create_lead(lead_hash)
      lead_hash = { :token_rdstation => @token, :identificador => "integração" }.merge(lead_hash)
      self.class.post('/api/1.2/conversions', { :body => lead_hash })
    end
  end
end
