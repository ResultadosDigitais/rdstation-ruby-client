require 'spec_helper'

RSpec.describe RDStation::Authentication do
  let(:authentication) { described_class.new('client_id', 'client_secret') }

  describe '#authenticate' do
    before do
      stub_request(:post, 'https://api.rd.services/auth/token')
        .with(
          headers: {
            'Accept-Encoding' => 'identity'
          },
          body: {
            client_id: 'client_id',
            client_secret: 'client_secret',
            code: '1234'
          }.to_json
        )
        .to_return(
          headers: { 'Content-Type' => 'application/json' },
          body: {
            error_type: 'ACCESS_DENIED',
            error_message: 'Wrong credentials provided.'
          }.to_json
        )

      stub_request(:post, 'https://api.rd.services/auth/token')
        .with(
          headers: {
            'Accept-Encoding' => 'identity'
          },
          body: {
            client_id: 'client_id',
            client_secret: 'client_secret',
            code: '123'
          }.to_json
        )
        .to_return(
          headers: { 'Content-Type' => 'application/json' },
          body: {
            'access_token' => '123456',
            'expires_in' => 86_400,
            'refresh_token' => 'refreshtoken'
          }.to_json
        )

        stub_request(:post, 'https://api.rd.services/auth/token')
          .with(
            headers: {
              'Accept-Encoding' => 'identity'
            },
            body: {
              client_id: 'client_id',
              client_secret: 'client_secret',
              code: '12345'
            }.to_json
          )
          .to_return(
            headers: {
              'Content-Type' => 'application/json',
            },
            body: {
              error_type: 'EXPIRED_CODE_GRANT',
              error_message: 'The authorization code grant has expired.'
            }.to_json
          )
    end

    context 'when the code is valid' do
      let(:credentials) do
        {
          'access_token' => '123456',
          'expires_in' => 86_400,
          'refresh_token' => 'refreshtoken'
        }
      end

      it 'returns the credentials' do
        credentials_request = authentication.authenticate('123')
        expect(credentials_request).to eq(credentials)
      end
    end

    context 'when the code is invalid' do
      it 'returns an auth error' do
        expect do
          authentication.authenticate('1234')
        end.to raise_error(RDStation::Error::InvalidCredentials)
      end
    end

    context 'when the code has expired' do
      it 'returns an expired code error' do
        expect do
          authentication.authenticate('12345')
        end.to raise_error(RDStation::Error::ExpiredCodeGrant)
      end
    end
  end
end
