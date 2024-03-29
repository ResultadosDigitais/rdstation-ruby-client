require 'spec_helper'

RSpec.describe RDStation do
  let(:client_id) { 'client_id' }
  let(:client_secret) { 'client_secret' }
  let(:base_host) { 'https://test-api.rd.services' }

  before do
    RDStation.configure do |config|
      config.client_id = client_id
      config.client_secret = client_secret
      config.base_host = base_host
    end
  end

  after { RDStation.configure {} }

  describe '.configure' do
    it 'sets the configuration' do
      expect(RDStation.configuration.client_id).to eq(client_id)
      expect(RDStation.configuration.client_secret).to eq(client_secret)
      expect(RDStation.configuration.base_host).to eq(base_host)
    end
  end

  describe '.host' do
    context 'when base_host is defined in configuration' do
      it 'returns specified host' do
        expect(RDStation.host).to eq(base_host)
      end
    end

    context 'when base_host is not defined in configuration' do
      it 'returns default host' do
        RDStation.configure {}

        expect(RDStation.host).to eq('https://api.rd.services')
      end
    end
  end
end
