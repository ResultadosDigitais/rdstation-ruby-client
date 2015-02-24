require 'spec_helper'

describe RDStation do
    let(:rdstation_client) { RDStation::Client.new(ENV['RD_STATION_TOKEN'],
                                                   ENV['RD_STATION_TOKEN_PRIVATE']) }
    let(:lead_email) { "iginosms@gmail.com" }
    let(:amount) { 300}


  context "#change_lead_status" do
    before do
      VCR.use_cassette('change_lead_status') do
         @response = rdstation_client.change_lead_status(email: lead_email,  status: 'won', value: amount)
      end
    end
    it 'should see the vars' do
      expect(lead_email).to_not be_nil
      expect(amount).to be_a_kind_of(Numeric)
    end
    it 'work?' do
      expect(@response.code).to eql(200)
    end

  end

end
