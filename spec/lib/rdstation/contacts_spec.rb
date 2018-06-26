require 'spec_helper'

RSpec.describe RDStation::Contacts do
  before do
    APIRequests::Contact.stub
  end

  describe '#get_contact' do
    context 'with a valid auth token' do
      let(:contacts) do
        described_class.new(APIRequests::Contact::VALID_AUTH_TOKEN)
      end

      context 'when the contact exists' do
        let(:expected_contact) do
          APIRequests::Contact::CONTACT_RESPONSE[:body]
        end

        it 'returns the contact' do
          response = contacts.get_contact('valid_uuid')
          expect(response).to eq(expected_contact)
        end
      end

      context 'when the contact does not exist' do
        it 'raises a not found error' do

        end
      end
    end

    context 'with an invalid auth token' do

    end

    context 'with an expired auth token' do

    end
  end

  describe '#get_contact_by_email' do

  end
end
