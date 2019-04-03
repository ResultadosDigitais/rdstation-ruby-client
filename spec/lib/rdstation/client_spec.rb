require 'spec_helper'

RSpec.describe RDStation::Client do

  describe "access_token" do
    context "when access_token is given" do
      let(:token) { "asidhkajshkkjgc" }

      before do
        RDStation::Client.configure do |config|
          config[:access_token] = token
        end
      end

      after do
        RDStation::Client.configure do |config|
          config.delete(:access_token)
        end
      end

      it "instantiates it's services using this token" do
        expect(RDStation::Contacts).to receive(:new).with({ access_token: token })
        expect(RDStation::Events).to receive(:new).with({ access_token: token })
        expect(RDStation::Fields).to receive(:new).with({ access_token: token })
        expect(RDStation::Webhooks).to receive(:new).with({ access_token: token })
        described_class.contacts
        described_class.events
        described_class.fields
        described_class.webhooks
      end

      it "returns the correct services" do
        expect(described_class.contacts).to be_a(RDStation::Contacts)
        expect(described_class.events).to be_a(RDStation::Events)
        expect(described_class.fields).to be_a(RDStation::Fields)
        expect(described_class.webhooks).to be_a(RDStation::Webhooks)
      end
    end

    context "when access_token is not given" do
      it "raises an error" do
        expect { described_class.contacts }.to raise_error(RDStation::InvalidConfiguration)
        expect { described_class.events }.to raise_error(RDStation::InvalidConfiguration)
        expect { described_class.fields }.to raise_error(RDStation::InvalidConfiguration)
        expect { described_class.webhooks }.to raise_error(RDStation::InvalidConfiguration)
      end
    end
  end
end
