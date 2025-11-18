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
    # param identifier_type:
    #   The type of identifier: :uuid, :email, or :phone
    # param identifier_value:
    #   The value of the identifier
    #
    def by_identifier(identifier_type, identifier_value)
      raise ArgumentError, "Invalid identifier type: #{identifier_type}" unless valid_identifier_type?(identifier_type)

      retryable_request(@authorization) do |authorization|
        path = build_identifier_path(identifier_type, identifier_value)
        response = self.class.get(base_url(path), headers: authorization.headers)
        ApiResponse.build(response)
      end
    end

    def by_uuid(uuid)
      by_identifier(:uuid, uuid)
    end

    def by_email(email)
      by_identifier(:email, email)
    end

    def by_phone(phone)
      by_identifier(:phone, phone)
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

    def valid_identifier_type?(type)
      %i[uuid email phone].include?(type)
    end

    def build_identifier_path(identifier_type, identifier_value)
      case identifier_type
      when :uuid
        identifier_value
      when :email, :phone
        "#{identifier_type}:#{identifier_value}"
      end
    end

    def base_url(path = '')
      "#{RDStation.host}/platform/contacts/#{path}"
    end
  end
end
