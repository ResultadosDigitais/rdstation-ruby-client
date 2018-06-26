module APIRequests
  module Contact
    CONTACTS_ENDPOINT = 'https://api.rd.services/platform/contacts/valid_uuid'.freeze
    VALID_UUID = 'valid_uuid'.freeze
    VALID_AUTH_TOKEN = 'valid_auth_token'.freeze

    CONTACT_RESPONSE = {
      status: 200,
      body: {
        name: 'Lead',
        email: 'email@example.org'
      }.to_json
    }.freeze

    def self.stub
      WebMock.stub_request(:get, CONTACTS_ENDPOINT)
             .with(
               headers: {
                 'Authorization' => 'Bearer valid_auth_token',
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(CONTACT_RESPONSE)
    end
  end
end
