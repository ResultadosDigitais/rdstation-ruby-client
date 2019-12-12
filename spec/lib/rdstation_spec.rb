require 'spec_helper'

RSpec.describe RDStation do
  describe '.configure' do
    let(:client_id) { 'client_id' }
    let(:client_secret) { 'client_secret' }

    it 'sets the configuration' do
      RDStation.configure do |config|
        config.client_id = client_id
        config.client_secret = client_secret
      end

      expect(RDStation.configuration.client_id).to eq client_id
      expect(RDStation.configuration.client_secret).to eq client_secret
    end
  end
end
