require 'spec_helper'

RSpec.describe RDStation::Client do
  context "when access_token is given" do
    let(:access_token) { 'access_token' }
    let(:client) { described_class.new(access_token: access_token) }
    let(:mock_authorization) { double(RDStation::Authorization) }

    before { allow(RDStation::Authorization).to receive(:new).and_return mock_authorization }

    it 'returns Contacts endpoint' do
      expect(RDStation::Contacts).to receive(:new).with({ authorization: mock_authorization }).and_call_original
      expect(client.contacts).to be_instance_of RDStation::Contacts
    end

    it 'returns Events endpoint' do
      expect(RDStation::Events).to receive(:new).with({ authorization: mock_authorization }).and_call_original
      expect(client.events).to be_instance_of RDStation::Events
    end

    it 'returns Fields endpoint' do
      expect(RDStation::Fields).to receive(:new).with({ authorization: mock_authorization }).and_call_original
      expect(client.fields).to be_instance_of RDStation::Fields
    end

    it 'returns Webhooks endpoint' do
      expect(RDStation::Webhooks).to receive(:new).with({ authorization: mock_authorization }).and_call_original
      expect(client.webhooks).to be_instance_of RDStation::Webhooks
    end

    it 'returns Account endpoing' do
      expect(RDStation::Account).to receive(:new).with({ authorization: mock_authorization }).and_call_original
      expect(client.account).to be_instance_of RDStation::Account
    end
  end

  context "when access_token isn't given" do
    it "raises an ArgumentError exception" do
      expect{ described_class.new(access_token: nil) }.to raise_error(ArgumentError)
    end
  end
end
