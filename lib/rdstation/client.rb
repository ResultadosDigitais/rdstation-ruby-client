module RDStation
  #
  # Mais informações em https://www.rdstation.com.br/docs/api
  #
  class Client
    include HTTParty

    def initialize(rdstation_token, auth_token, identifier="integração")
      @identificador = identifier
      @rdstation_token = rdstation_token
      @auth_token = auth_token
    end

    #
    # A hash de lead pode conter os parametros
    # (requerido)  :identificador
    # (requerido)  :email
    #              :nome
    #              :empresa
    #              :cargo
    #              :telefone
    #              :celular
    #              :website
    #              :twitter
    #              :c_utmz
    #
    def create_lead(lead_hash)
      lead_hash = rdstation_token_hash.merge(identifier_hash).merge(lead_hash)
      post_with_body("/conversions", {:body => lead_hash})
    end

    #
    # param lead:
    #   id ou email do Lead a ser alterado
    #
    # param lead_hash:
    #   Hash contendo:
    #     :lifecycle_stage
    #       0 - Lead; 1 - Lead Qualificado; 2 - Cliente
    #     :opportunity
    #       true ou false
    #
    def change_lead(lead, lead_hash)
      lead_hash = auth_token_hash.merge({:lead => lead_hash})
      put_with_body("/leads/#{lead}", :body => lead_hash.to_json, :headers => {'Content-Type' => 'application/json'})
    end

    def change_lead_status(lead_hash)
      put_with_body("/services/#{@auth_token}/generic", :body => lead_hash)
    end

  private
    def base_url
      "https://www.rdstation.com.br/api/1.2"
    end

    def rdstation_token_hash
      { :token_rdstation => @rdstation_token }
    end

    def auth_token_hash
      { :auth_token => @auth_token }
    end

    def identifier_hash
      { :identificador => @identificador }
    end

    def post_with_body(path, opts)
      self.class.post("#{base_url}#{path}", opts)
    end

    def put_with_body(path, opts)
      self.class.put("#{base_url}#{path}", opts)
    end
  end
end
