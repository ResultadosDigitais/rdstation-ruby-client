# encoding: utf-8
module RDStation
  # Mais informações em: https://developers.rdstation.com/pt-BR/reference/contacts
  class Contacts
    include HTTParty

    def initialize(auth_token)
      @auth_token = auth_token
    end

    #
    # params uuid:
    #   O UUID único associado para cada contato do RD Station
    #
    def get_contact(uuid)
      self.class.get(base_url(uuid), :headers => required_headers)
    end

    def get_contact_by_email(email)
      self.class.get(base_url("email:#{email}"), :headers => required_headers)
    end

    # A hash do Contato pode conter os seguintes parâmetros
    # :email
    # :name
    # :job_title
    # :linkedin
    # :facebook
    # :twitter
    # :personal_phone
    # :mobile_phone
    # :website
    # :tags
    def update_contact(uuid, contact_hash)
      self.class.patch(base_url(uuid), :body => contact_hash.to_json, :headers => required_headers)
    end

    #
    # param identifier:
    #   Qual campo será usado para identificar o Contato
    # param identifier_value:
    #   Valor para o identificador dado
    # param contact_hash:
    #   Dados do contato
    #
    def upsert_contact(identifier, identifier_value, contact_hash)
      path = "#{identifier}:#{identifier_value}"
      self.class.patch(base_url(path), :body => contact_hash.to_json, :headers => required_headers)
    end

    private

      def base_url(path = "")
        "https://api.rd.services/platform/contacts/#{path}"
      end

      def required_headers
        { "Authorization" => "Bearer #{@auth_token}", "Content-Type" => "application/json" }
      end
  end
end
