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

  let(:valid_access_token) { 'valid_access_token' }
  let(:invalid_access_token) { 'invalid_access_token' }
  let(:expired_access_token) { 'expired_access_token' }

  let(:contact_with_valid_token) do
    described_class.new(authorization_header: RDStation::AuthorizationHeader.new(access_token: valid_access_token))
  end
  let(:contact_with_expired_token) do
    described_class.new(authorization_header: RDStation::AuthorizationHeader.new(access_token: expired_access_token))
  end
  let(:contact_with_invalid_token) do
    described_class.new(authorization_header: RDStation::AuthorizationHeader.new(access_token: invalid_access_token))
  end
  

  let(:valid_headers) do
    {
      'Authorization' => "Bearer #{valid_access_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:invalid_token_headers) do
    {
      'Authorization' => "Bearer #{invalid_access_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:expired_token_headers) do
    {
      'Authorization' => "Bearer #{expired_access_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:not_found_response) do
    {
      status: 404,
      body: {
        errors: {
          error_type: 'RESOURCE_NOT_FOUND',
          error_message: 'Lead not found.'
        }
      }.to_json
    }
  end

  let(:invalid_token_response) do
    {
      status: 401,
      body: {
        errors: {
          error_type: 'UNAUTHORIZED',
          error_message: 'Invalid token.'
        }
      }.to_json
    }
  end

  let(:conflicting_field_response) do
    {
      status: 400,
      body: {
        errors: {
          error_type: 'CONFLICTING_FIELD',
          error_message: 'The payload contains an attribute that was used to identify the resource.'
        }
      }.to_json
    }
  end

  let(:unrecognized_error) do
    {
      status: 400,
      body: {
        errors: {
          error_type: 'unrecognized error',
          error_message: 'Unexpected error.'
        }
      }.to_json
    }
  end

  let(:expired_token_response) do
    {
      status: 401,
      headers: { 'WWW-Authenticate' => 'Bearer realm="https://api.rd.services/", error="expired_token", error_description="The access token expired"' },
      body: {
        errors: {
          error_type: 'UNAUTHORIZED',
          error_message: 'Invalid token.'
        }
      }.to_json
    }
  end

  describe '#by_uuid' do
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
          response = contact_with_valid_token.by_uuid('valid_uuid')
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
            contact_with_valid_token.by_uuid(invalid_uuid)
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
          contact_with_invalid_token.by_uuid(valid_uuid)
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
          contact_with_expired_token.by_uuid(valid_uuid)
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end

  describe '#by_email' do
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
          response = contact_with_valid_token.by_email(valid_email)
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
            contact_with_valid_token.by_email(invalid_email)
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
          contact_with_invalid_token.by_email(valid_email)
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
          contact_with_expired_token.by_email(valid_email)
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end

  describe '#update' do
    context 'with a valid access_token' do
      let(:valid_access_token) { 'valid_access_token' }
      let(:headers) do
        {
          'Authorization' => "Bearer #{valid_access_token}",
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
          updated_contact = contact_with_valid_token.update('valid_uuid', contact)
          expect(updated_contact).to eq(contact)
        end
      end

      context 'when the contact does not exist' do
        before do
          stub_request(:patch, endpoint_with_invalid_uuid)
            .with(headers: headers)
            .to_return(not_found_response)
        end

        it 'raises a not found error' do
          expect do
            contact_with_valid_token.update(invalid_uuid, {})
          end.to raise_error(RDStation::Error::ResourceNotFound)
        end
      end
    end

    context 'with an invalid auth token' do
      let(:invalid_access_token) { 'invalid_access_token' }
      let(:headers) do
        {
          'Authorization' => "Bearer #{invalid_access_token}",
          'Content-Type' => 'application/json'
        }
      end

      before do
        stub_request(:patch, endpoint_with_valid_uuid)
          .with(headers: headers)
          .to_return(invalid_token_response)
      end

      it 'raises an invalid token error' do
        expect do
          contact_with_invalid_token.update('valid_uuid', {})
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end

    context 'with an expired auth token' do
      let(:expired_access_token) { 'expired_access_token' }
      let(:headers) do
        {
          'Authorization' => "Bearer #{expired_access_token}",
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
          contact_with_expired_token.update('valid_uuid', {})
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end

  describe '#upsert' do
    context 'with a valid access_token' do
      let(:valid_access_token) { 'valid_access_token' }

      let(:headers) do
        {
          'Authorization' => "Bearer #{valid_access_token}",
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
          updated_contact = contact_with_valid_token.upsert('email', 'valid@email.com', contact)
          expect(updated_contact).to eq(contact)
        end
      end

      context 'when the contact does not exist' do
        before do
          stub_request(:patch, endpoint_with_invalid_email)
            .with(headers: headers)
            .to_return(not_found_response)
        end

        it 'raises a not found error' do
          expect do
            contact_with_valid_token.upsert('email', invalid_email, {})
          end.to raise_error(RDStation::Error::ResourceNotFound)
        end
      end

      context 'when the payload has a conflicting field' do
        let(:conflicting_payload) { { 'email' => valid_email } }

        before do
          stub_request(:patch, endpoint_with_valid_email)
            .with(headers: headers)
            .to_return(conflicting_field_response)
        end

        it 'raises a conflicting field error' do
          expect do
            contact_with_valid_token.upsert('email', valid_email, conflicting_payload)
          end.to raise_error(RDStation::Error::ConflictingField)
        end
      end

      context 'when an unrecognized error occurs' do
        before do
          stub_request(:patch, endpoint_with_valid_email)
            .with(headers: headers)
            .to_return(unrecognized_error)
        end

        it 'raises an default error' do
          expect do
            contact_with_valid_token.upsert('email', valid_email, {})
          end.to raise_error(RDStation::Error::Default)
        end
      end
    end

    context 'with an invalid auth token' do
      let(:invalid_access_token) { 'invalid_access_token' }
      let(:headers) do
        {
          'Authorization' => "Bearer #{invalid_access_token}",
          'Content-Type' => 'application/json'
        }
      end

      before do
        stub_request(:patch, endpoint_with_valid_email)
          .with(headers: headers)
          .to_return(invalid_token_response)
      end

      it 'raises an invalid token error' do
        expect do
          contact_with_invalid_token.upsert('email', valid_email, {})
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end

    context 'with an expired auth token' do
      let(:expired_access_token) { 'expired_access_token' }
      let(:headers) do
        {
          'Authorization' => "Bearer #{expired_access_token}",
          'Content-Type' => 'application/json'
        }
      end

      before do
        stub_request(:patch, endpoint_with_valid_email)
          .with(headers: headers)
          .to_return(expired_token_response)
      end

      it 'raises an expired token error' do
        expect do
          contact_with_expired_token.upsert('email', valid_email, {})
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end
end
