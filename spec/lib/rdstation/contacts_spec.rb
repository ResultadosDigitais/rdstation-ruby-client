require 'spec_helper'

RSpec.describe RDStation::Contacts do
  before do
    APIRequests::Contact.stub
  end

  let(:valid_auth_token) { 'valid_auth_token' }
  let(:invalid_auth_token) { 'invalid_auth_token' }
  let(:expired_auth_token) { 'expired_auth_token' }

  let(:contact_with_valid_token) { described_class.new(valid_auth_token) }
  let(:contact_with_expired_token) { described_class.new(expired_auth_token) }
  let(:contact_with_invalid_token) { described_class.new(invalid_auth_token) }

  describe '#get_contact' do
    context 'with a valid auth token' do
      context 'when the contact exists' do
        let(:expected_contact) do
          JSON.parse(APIRequests::Contact::CONTACT_RESPONSE[:body])
        end

        it 'returns the contact' do
          response = contact_with_valid_token.get_contact(APIRequests::Contact::VALID_UUID)
          expect(response).to eq(expected_contact)
        end
      end

      context 'when the contact does not exist' do
        it 'raises a not found error' do
          expect do
            contact_with_valid_token.get_contact(APIRequests::Contact::INVALID_UUID)
          end.to raise_error(RDStation::Error::ResourceNotFound)
        end
      end
    end

    context 'with an invalid auth token' do
      it 'raises an invalid token error' do
        expect do
          contact_with_invalid_token.get_contact(APIRequests::Contact::VALID_UUID)
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end

    context 'with an expired auth token' do
      it 'raises a expired token error' do
        expect do
          contact_with_expired_token.get_contact(APIRequests::Contact::VALID_UUID)
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end

  describe '#get_contact_by_email' do
    context 'with a valid auth token' do
      context 'when the contact exists' do
        let(:expected_contact) do
          JSON.parse(APIRequests::Contact::CONTACT_RESPONSE[:body])
        end

        it 'returns the contact' do
          response = contact_with_valid_token.get_contact_by_email(APIRequests::Contact::VALID_EMAIL)
          expect(response).to eq(expected_contact)
        end
      end

      context 'when the contact does not exist' do
        it 'raises a not found error' do
          expect do
            contact_with_valid_token.get_contact_by_email(APIRequests::Contact::INVALID_EMAIL)
          end.to raise_error(RDStation::Error::ResourceNotFound)
        end
      end
    end

    context 'with an invalid auth token' do
      it 'raises an invalid token error' do
        expect do
          contact_with_invalid_token.get_contact_by_email(APIRequests::Contact::VALID_EMAIL)
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end

    context 'with an expired auth token' do
      it 'raises a expired token error' do
        expect do
          contact_with_expired_token.get_contact_by_email(APIRequests::Contact::VALID_EMAIL)
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end

  describe '#update_contact' do
    context 'with a valid auth_token' do
      let(:valid_auth_token) { 'valid_auth_token' }
      let(:headers) do
        {
          'Authorization' => "Bearer #{valid_auth_token}",
          'Content-Type' => 'application/json'
        }
      end

      context 'with valid params' do
        let(:contact) do
          { 'name' => 'Lead', 'email' => 'valid@email.com' }
        end

        before do
          stub_request(:patch, 'https://api.rd.services/platform/contacts/valid_uuid')
            .with(headers: headers)
            .to_return(status: 200, body: contact.to_json)
        end

        it 'returns the updated contact' do
          updated_contact = contact_with_valid_token.update_contact('valid_uuid', contact)
          expect(updated_contact).to eq(contact)
        end
      end

      context 'when the contact does not exist' do
        let(:not_found) do
          {
            error_type: 'RESOURCE_NOT_FOUND',
            error_message: 'Lead not found.'
          }
        end

        before do
          stub_request(:patch, 'https://api.rd.services/platform/contacts/not_found_contact')
            .with(headers: headers)
            .to_return(status: 404, body: not_found.to_json)
        end

        it 'raises a not found error' do
          expect do
            contact_with_valid_token.update_contact('not_found_contact', {})
          end.to raise_error(RDStation::Error::ResourceNotFound)
        end
      end
    end

    context 'with an invalid auth token' do
      let(:invalid_auth_token) { 'invalid_auth_token' }
      let(:headers) do
        {
          'Authorization' => "Bearer #{invalid_auth_token}",
          'Content-Type' => 'application/json'
        }
      end

      let(:invalid_token_response) do
        {
          error_type: 'UNAUTHORIZED',
          error_message: 'Invalid token.'
        }
      end

      before do
        stub_request(:patch, 'https://api.rd.services/platform/contacts/valid_uuid')
          .with(headers: headers)
          .to_return(status: 401, body: invalid_token_response.to_json)
      end

      it 'raises an invalid token error' do
        expect do
          contact_with_invalid_token.update_contact('valid_uuid', {})
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end

    context 'with an expired auth token' do
      let(:expired_auth_token) { 'expired_auth_token' }
      let(:headers) do
        {
          'Authorization' => "Bearer #{expired_auth_token}",
          'Content-Type' => 'application/json'
        }
      end

      let(:expired_token_response) do
        {
          error_type: 'UNAUTHORIZED',
          error_message: 'Invalid token.'
        }
      end

      before do
        stub_request(:patch, 'https://api.rd.services/platform/contacts/valid_uuid')
          .with(headers: headers)
          .to_return(
            status: 401,
            headers: { 'WWW-Authenticate' => 'Bearer realm="https://api.rd.services/", error="expired_token", error_description="The access token expired"' },
            body: expired_token_response.to_json
          )
      end

      it 'raises a expired token error' do
        expect do
          contact_with_expired_token.update_contact('valid_uuid', {})
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end




  describe '#upsert_contact' do
    context 'with a valid auth_token' do
      let(:valid_auth_token) { 'valid_auth_token' }

      let(:headers) do
        {
          'Authorization' => "Bearer #{valid_auth_token}",
          'Content-Type' => 'application/json'
        }
      end

      context 'with valid params' do
        let(:contact) do
          { 'name' => 'Lead', 'job_title' => 'Developer' }
        end

        before do
          stub_request(:patch, 'https://api.rd.services/platform/contacts/email:valid@email.com')
            .with(headers: headers)
            .to_return(status: 200, body: contact.to_json)
        end

        it 'returns the updated contact' do
          updated_contact = contact_with_valid_token.upsert_contact('email', 'valid@email.com', contact)
          expect(updated_contact).to eq(contact)
        end
      end

      context 'when the contact does not exist' do
        let(:not_found) do
          {
            error_type: 'RESOURCE_NOT_FOUND',
            error_message: 'Lead not found.'
          }
        end

        before do
          stub_request(:patch, 'https://api.rd.services/platform/contacts/email:not_found_contact')
            .with(headers: headers)
            .to_return(status: 404, body: not_found.to_json)
        end

        it 'raises a not found error' do
          expect do
            contact_with_valid_token.upsert_contact('email', 'not_found_contact', {})
          end.to raise_error(RDStation::Error::ResourceNotFound)
        end
      end
    end

    context 'with an invalid auth token' do
      let(:invalid_auth_token) { 'invalid_auth_token' }
      let(:headers) do
        {
          'Authorization' => "Bearer #{invalid_auth_token}",
          'Content-Type' => 'application/json'
        }
      end

      let(:invalid_token_response) do
        {
          error_type: 'UNAUTHORIZED',
          error_message: 'Invalid token.'
        }
      end

      before do
        stub_request(:patch, 'https://api.rd.services/platform/contacts/email:valid@email.com')
          .with(headers: headers)
          .to_return(status: 401, body: invalid_token_response.to_json)
      end

      it 'raises an invalid token error' do
        expect do
          contact_with_invalid_token.upsert_contact('email', 'valid@email.com', {})
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end

    context 'with an expired auth token' do
      let(:expired_auth_token) { 'expired_auth_token' }
      let(:headers) do
        {
          'Authorization' => "Bearer #{expired_auth_token}",
          'Content-Type' => 'application/json'
        }
      end

      let(:expired_token_response) do
        {
          error_type: 'UNAUTHORIZED',
          error_message: 'Invalid token.'
        }
      end

      before do
        stub_request(:patch, 'https://api.rd.services/platform/contacts/email:valid@email.com')
          .with(headers: headers)
          .to_return(
            status: 401,
            headers: { 'WWW-Authenticate' => 'Bearer realm="https://api.rd.services/", error="expired_token", error_description="The access token expired"' },
            body: expired_token_response.to_json
          )
      end

      it 'raises a expired token error' do
        expect do
          contact_with_expired_token.upsert_contact('email', 'valid@email.com', {})
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end
end
