require 'spec_helper'

RSpec.describe RDStation::Account do
  let(:client) do
    described_class.new(authorization: RDStation::Authorization.new(access_token: 'access_token'))
  end

  let(:endpoint) { 'https://api.rd.services/marketing/account_info' }

  let(:headers) do
    {
      'Authorization' => 'Bearer access_token',
      'Content-Type' => 'application/json'
    }
  end

  let(:error_handler) do
    instance_double(RDStation::ErrorHandler, raise_error: 'mock raised errors')
  end

  before do
    allow(RDStation::ErrorHandler).to receive(:new).and_return(error_handler)
  end

  describe '#info' do
    it 'calls retryable_request' do
      expect(client).to receive(:retryable_request)
      client.info
    end

    context 'when the request is successful' do
      before do
        stub_request(:get, endpoint)
          .with(headers: headers)
          .to_return(status: 200, body: {name: 'www.rdstation.com'}.to_json)
      end

      it 'return RDSM account information' do
        response = client.info
        expect(response).to eq({ "name" => "www.rdstation.com"})
      end
    end

    context 'when the response contains errors' do
      before do
        stub_request(:get, endpoint)
          .with(headers: headers)
          .to_return(status: 404, body: { 'errors' => ['not found'] }.to_json)
      end

      it 'calls raise_error on error handler' do
        client.info
        expect(error_handler).to have_received(:raise_error)
      end
    end
  end
end
