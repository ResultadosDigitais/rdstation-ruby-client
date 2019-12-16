require 'spec_helper'

RSpec.describe RDStation::Authorization do
  
  describe ".initialize" do
    context "when access_token is nil" do
      it "raises an error" do
        expect do
          described_class.new(access_token: nil)
        end.to raise_error(ArgumentError)
      end
    end
  end
  
  describe "#headers" do
    let(:access_token) { 'access_token' }
    
    it "generates the correct header" do
      header = described_class.new(access_token: access_token).headers
      expect(header['Authorization']).to eq "Bearer #{access_token}"
      expect(header['Content-Type']).to eq "application/json"
    end
  end
end