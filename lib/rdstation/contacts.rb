# encoding: utf-8
module RDStation
  # More info: https://developers.rdstation.com/pt-BR/reference/contacts
  class Contacts
    include HTTParty
    include ::RDStation::RetryableRequest

    def initialize(authorization:)
      @authorization = authorization
    end

    #
    # param uuid:
    #   The unique uuid associated to each RD Station Contact.
    #
    def by_uuid(uuid)
      retryable_request(@authorization) do |authorization|
        response = self.class.get(base_url(uuid), headers: authorization.headers)
        ApiResponse.build(response)
      end
    end

    def by_email(email)
      retryable_request(@authorization) do |authorization|
        response = self.class.get(base_url("email:#{email}"), headers: authorization.headers)
        ApiResponse.build(response)
      end
    end

    # The Contact hash may contain the following parameters:
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
    def update(uuid, contact_hash)
      retryable_request(@authorization) do |authorization|
        response = self.class.patch(base_url(uuid), :body => contact_hash.to_json, :headers => authorization.headers)
        ApiResponse.build(response)
      end
    end

    #
    # param identifier:
    #   Field that will be used to identify the contact.
    # param identifier_value:
    #   Value to the identifier given.
    # param contact_hash:
    #   Contact data
    #
    def upsert(identifier, identifier_value, contact_hash)
      retryable_request(@authorization) do |authorization|
        path = "#{identifier}:#{identifier_value}"
        response = self.class.patch(base_url(path), body: contact_hash.to_json, headers: authorization.headers)
        ApiResponse.build(response)
      end
    end

    private

    def base_url(path = '')
      "#{RDStation.host}/platform/contacts/#{path}"
    end
  end
end
