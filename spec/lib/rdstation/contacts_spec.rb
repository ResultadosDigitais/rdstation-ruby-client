require 'spec_helper'

RSpec.describe RDStation::Contacts do
  let(:valid_uuid) { 'valid_uuid' }
  let(:invalid_uuid) { 'invalid_uuid' }
  let(:valid_email) { 'valid@email.com' }
  let(:invalid_email) { 'invalid@email.com' }

  let(:endpoint_with_valid_uuid) { "https://api.rd.services/platform/contacts/#{valid_uuid}" }
  let(:endpoint_with_invalid_uuid) { "https://api.rd.services/platform/contacts/#{invalid_uuid}" }
  let(:endpoint_with_valid_email) { "https://api.rd.services/platform/contacts/email:#{valid_email}" }
  let(:endpoint_with_invalid_email) { "https://api.rd.services/platform/contacts/email:#{invalid_email}" }

  let(:valid_auth_token) { 'valid_auth_token' }
  let(:invalid_auth_token) { 'invalid_auth_token' }
  let(:expired_auth_token) { 'expired_auth_token' }

  let(:contact_with_valid_token) { described_class.new(valid_auth_token) }
  let(:contact_with_expired_token) { described_class.new(expired_auth_token) }
  let(:contact_with_invalid_token) { described_class.new(invalid_auth_token) }

  let(:valid_headers) do
    {
      'Authorization' => "Bearer #{valid_auth_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:invalid_token_headers) do
    {
      'Authorization' => "Bearer #{invalid_auth_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:expired_token_headers) do
    {
      'Authorization' => "Bearer #{expired_auth_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:not_found_response) do
    {
      status: 404,
      body: {
        error_type: 'RESOURCE_NOT_FOUND',
        error_message: 'Lead not found.'
      }.to_json
    }
  end

  let(:invalid_token_response) do
    {
      status: 401,
      body: {
        error_type: 'UNAUTHORIZED',
        error_message: 'Invalid token.'
      }.to_json
    }
  end

  let(:expired_token_response) do
    {
      status: 401,
      headers: { 'WWW-Authenticate' => 'Bearer realm="https://api.rd.services/", error="expired_token", error_description="The access token expired"' },
      body: {
        error_type: 'UNAUTHORIZED',
        error_message: 'Invalid token.'
      }.to_json
    }
  end

  describe '#get_contact' do
    context 'with a valid auth token' do
      context 'when the contact exists' do
        let(:contact) do
          { 'name' => 'Lead', 'email' => 'valid@email.com' }
        end

        before do
          stub_request(:get, endpoint_with_valid_uuid)
            .with(headers: valid_headers)
            .to_return(status: 200, body: contact.to_json)
        end

        it 'returns the contact' do
          response = contact_with_valid_token.get_contact('valid_uuid')
          expect(response).to eq(contact)
        end
      end

      context 'when the contact does not exist' do
        before do
          stub_request(:get, endpoint_with_invalid_uuid)
            .with(headers: valid_headers)
            .to_return(not_found_response)
        end

        it 'raises a not found error' do
          expect do
            contact_with_valid_token.get_contact(invalid_uuid)
          end.to raise_error(RDStation::Error::ResourceNotFound)
        end
      end
    end

    context 'with an invalid auth token' do
      before do
        stub_request(:get, endpoint_with_valid_uuid)
          .with(headers: invalid_token_headers)
          .to_return(invalid_token_response)
      end

      it 'raises an invalid token error' do
        expect do
          contact_with_invalid_token.get_contact(valid_uuid)
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end

    context 'with an expired auth token' do
      before do
        stub_request(:get, endpoint_with_valid_uuid)
          .with(headers: expired_token_headers)
          .to_return(expired_token_response)
      end

      it 'raises a expired token error' do
        expect do
          contact_with_expired_token.get_contact(valid_uuid)
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end

  describe '#get_contact_by_email' do
    context 'with a valid auth token' do
      context 'when the contact exists' do
        let(:contact) do
          { 'name' => 'Lead', 'email' => 'valid@email.com' }
        end

        before do
          stub_request(:get, endpoint_with_valid_email)
            .with(headers: valid_headers)
            .to_return(status: 200, body: contact.to_json)
        end

        it 'returns the contact' do
          response = contact_with_valid_token.get_contact_by_email(valid_email)
          expect(response).to eq(contact)
        end
      end

      context 'when the contact does not exist' do
        before do
          stub_request(:get, endpoint_with_invalid_email)
            .with(headers: valid_headers)
            .to_return(not_found_response)
        end

        it 'raises a not found error' do
          expect do
            contact_with_valid_token.get_contact_by_email(invalid_email)
          end.to raise_error(RDStation::Error::ResourceNotFound)
        end
      end
    end

    context 'with an invalid auth token' do
      before do
        stub_request(:get, endpoint_with_valid_email)
          .with(headers: invalid_token_headers)
          .to_return(invalid_token_response)
      end

      it 'raises an invalid token error' do
        expect do
          contact_with_invalid_token.get_contact_by_email(valid_email)
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end

    context 'with an expired auth token' do
      before do
        stub_request(:get, endpoint_with_valid_email)
          .with(headers: expired_token_headers)
          .to_return(expired_token_response)
      end

      it 'raises a expired token error' do
        expect do
          contact_with_expired_token.get_contact_by_email(valid_email)
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
          stub_request(:patch, endpoint_with_valid_uuid)
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
          stub_request(:patch, endpoint_with_invalid_uuid)
            .with(headers: headers)
            .to_return(status: 404, body: not_found.to_json)
        end

        it 'raises a not found error' do
          expect do
            contact_with_valid_token.update_contact(invalid_uuid, {})
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
        stub_request(:patch, endpoint_with_valid_uuid)
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

      before do
        stub_request(:patch, endpoint_with_valid_uuid)
          .with(headers: headers)
          .to_return(expired_token_response)
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
          stub_request(:patch, endpoint_with_valid_email)
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
          stub_request(:patch, endpoint_with_invalid_email)
            .with(headers: headers)
            .to_return(status: 404, body: not_found.to_json)
        end

        it 'raises a not found error' do
          expect do
            contact_with_valid_token.upsert_contact('email', invalid_email, {})
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
        stub_request(:patch, endpoint_with_valid_email)
          .with(headers: headers)
          .to_return(status: 401, body: invalid_token_response.to_json)
      end

      it 'raises an invalid token error' do
        expect do
          contact_with_invalid_token.upsert_contact('email', valid_email, {})
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

      before do
        stub_request(:patch, endpoint_with_valid_email)
          .with(headers: headers)
          .to_return(expired_token_response)
      end

      it 'raises a expired token error' do
        expect do
          contact_with_expired_token.upsert_contact('email', valid_email, {})
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end
end
