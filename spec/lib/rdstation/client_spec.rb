require 'spec_helper'

RSpec.describe RDStation::Client do
  context "when access_token is given" do
    let(:access_token) { 'access_token' }
    let(:client) { described_class.new(access_token: access_token) }

    it "returns the correct endpoint" do
      expect(client.contacts).to be_a(RDStation::Contacts)
      expect(client.events).to be_a(RDStation::Events)
      expect(client.fields).to be_a(RDStation::Fields)
      expect(client.webhooks).to be_a(RDStation::Webhooks)
    end
    
    it "creates an authorization_header and initilizes the enpoints with this header" do
      mock_authorization_header = double(RDStation::AuthorizationHeader)
      expect(RDStation::AuthorizationHeader).to receive(:new)
        .with({ access_token: access_token})
        .and_return(mock_authorization_header)
      expect(RDStation::Contacts).to receive(:new).with({ authorization_header: mock_authorization_header })
      expect(RDStation::Events).to receive(:new).with({ authorization_header: mock_authorization_header })
      expect(RDStation::Fields).to receive(:new).with({ authorization_header: mock_authorization_header })
      expect(RDStation::Webhooks).to receive(:new).with({ authorization_header: mock_authorization_header })
      client.contacts
      client.events
      client.fields
      client.webhooks
    end
  end
end
