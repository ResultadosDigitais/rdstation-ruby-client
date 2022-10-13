# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RDStation::Fields do
  before do
    RDStation.configure do |config|
      config.base_host = 'https://sample.rd.services'
    end
  end

  after do
    RDStation.configure do |config|
      config.base_host = 'https://api.rd.services'
    end
  end

  let(:valid_access_token) { 'valid_access_token' }
  let(:rdstation_fields_with_valid_token) do
    described_class.new(authorization: RDStation::Authorization.new(access_token: valid_access_token))
  end

  let(:valid_headers) do
    {
      'Authorization' => "Bearer #{valid_access_token}",
      'Content-Type' => 'application/json'
    }
  end

  describe '#all' do
    let(:fields_endpoint) { 'https://sample.rd.services/platform/contacts/fields/' }
    let(:all_account_fields) do
      {
        'fields' => [
          {
            'uuid' => 'fdeba6ec-f1cf-4b13-b2ea-e93d47c0d828',
            'api_identifier' => 'name',
            'custom_field' => false,
            'data_type' => 'STRING',
            'name' => {
              'default' => 'nome',
              'pt-BR' => 'nome'
            },
            'label' => {
              'default' => 'Nome completo',
              'pt-BR' => 'Nome completo'
            },
            'presentation_type' => 'TEXT_INPUT',
            'validation_rules' => {}
          }
        ]
      }
    end

    it 'calls retryable_request' do
      expect(rdstation_fields_with_valid_token).to receive(:retryable_request)
      rdstation_fields_with_valid_token.all
    end

    context 'with a valid auth token' do
      before do
        stub_request(:get, fields_endpoint)
          .with(headers: valid_headers)
          .to_return(status: 200, body: all_account_fields.to_json)
      end

      it 'returns all account fields' do
        fields = rdstation_fields_with_valid_token.all
        expect(fields).to eq(all_account_fields)
      end
    end
  end
end
