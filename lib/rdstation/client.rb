module RDStation
  #
  # Mais informações em http://ajuda.rdstation.com.br/hc/pt-br/articles/204526429-Guia-de-integra%C3%A7%C3%B5es-com-o-RD-Station
  #
  class Client
    include HTTParty

    def initialize(rdstation_token, auth_token, identifier="integração")
      @identificador = identifier
      @rdstation_token = rdstation_token
      @auth_token = auth_token
    end

    #
    # A hash do Lead pode conter os seguintes parâmetros:
    # (obrigatório) :email
    #               :identificador
    #               :nome
    #               :empresa
    #               :cargo
    #               :telefone
    #               :celular
    #               :website
    #               :twitter
    #               :c_utmz
    #               :created_at
    #               :tags
    #
    # Caso algum parâmetro não seja identificado como campo padrão ou como
    # campo personalizado, este parâmetro desconhecido será gravado nos
    # "Detalhes do Lead".
    #
    def create_lead(lead_hash)
      lead_hash = rdstation_token_hash.merge(lead_hash)
      lead_hash = lead_hash.merge(identifier_hash) unless lead_hash.has_key?(:identificador)
      post_with_body("/conversions", {:body => lead_hash})
    end
    alias_method :update_lead_info, :create_lead

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
      post_with_body("/services/#{@auth_token}/generic", :body => lead_hash )
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
