require 'spec_helper'

RSpec.describe RDStation::Authentication do
  let(:authentication) do
    described_class.new(
      APIRequests::Authentication::CLIENT_ID,
      APIRequests::Authentication::CLIENT_SECRET
    )
  end

  describe '#authenticate' do
    before do
      APIRequests::Authentication.stub
    end

    context 'when the code is valid' do
      let(:credentials) do
        JSON.parse(APIRequests::Authentication::TOKEN_RESPONSE[:body])
      end

      it 'returns the credentials' do
        credentials_request = authentication.authenticate('valid_code')
        expect(credentials_request).to eq(credentials)
      end
    end

    context 'when the code is invalid' do
      it 'returns an auth error' do
        expect do
          authentication.authenticate('invalid_code')
        end.to raise_error(RDStation::Error::InvalidCredentials)
      end
    end

    context 'when the code has expired' do
      it 'returns an expired code error' do
        expect do
          authentication.authenticate('expired_code')
        end.to raise_error(RDStation::Error::ExpiredCodeGrant)
      end
    end
  end
end
