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
          JSON.parse(APIRequests::Contact::CONTACT_RESPONSE[:body])
        end

        it 'returns the contact' do
          response = contacts.get_contact(APIRequests::Contact::VALID_UUID)
          expect(response).to eq(expected_contact)
        end
      end

      context 'when the contact does not exist' do
        it 'raises a not found error' do
          expect do
            contacts.get_contact(APIRequests::Contact::INVALID_UUID)
          end.to raise_error(RDStation::Error::ResourceNotFound)
        end
      end
    end

    context 'with an invalid auth token' do
      let(:contacts) do
        described_class.new(APIRequests::Contact::INVALID_AUTH_TOKEN)
      end

      it 'raises a expired token error' do
        expect do
          contacts.get_contact(APIRequests::Contact::VALID_UUID)
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end

    context 'with an expired auth token' do
      let(:contacts) do
        described_class.new(APIRequests::Contact::EXPIRED_AUTH_TOKEN)
      end

      it 'raises a expired token error' do
        expect do
          contacts.get_contact(APIRequests::Contact::VALID_UUID)
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end

  describe '#get_contact_by_email' do
    context 'with a valid auth token' do
      let(:contacts) do
        described_class.new(APIRequests::Contact::VALID_AUTH_TOKEN)
      end

      context 'when the contact exists' do
        let(:expected_contact) do
          JSON.parse(APIRequests::Contact::CONTACT_RESPONSE[:body])
        end

        it 'returns the contact' do
          response = contacts.get_contact_by_email(APIRequests::Contact::VALID_EMAIL)
          expect(response).to eq(expected_contact)
        end
      end

      context 'when the contact does not exist' do
        it 'raises a not found error' do
          expect do
            contacts.get_contact_by_email(APIRequests::Contact::INVALID_EMAIL)
          end.to raise_error(RDStation::Error::ResourceNotFound)
        end
      end
    end

    context 'with an invalid auth token' do
      let(:contacts) do
        described_class.new(APIRequests::Contact::INVALID_AUTH_TOKEN)
      end

      it 'raises a expired token error' do
        expect do
          contacts.get_contact_by_email(APIRequests::Contact::VALID_EMAIL)
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end

    context 'with an expired auth token' do
      let(:contacts) do
        described_class.new(APIRequests::Contact::EXPIRED_AUTH_TOKEN)
      end

      it 'raises a expired token error' do
        expect do
          contacts.get_contact_by_email(APIRequests::Contact::VALID_EMAIL)
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end
end
