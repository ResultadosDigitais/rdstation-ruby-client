require 'spec_helper'

RSpec.describe RDStation::ApiResponse do
  describe ".build" do
    context "when the response HTTP status is 2xx" do
      let(:response) { OpenStruct.new(code: 200, body: '{}') }

      it "returns the response body" do
        expect(RDStation::ApiResponse.build(response)).to eq({})
      end
    end

    shared_examples_for 'call_error_handler' do
      it "calls error handler" do
        error_handler = instance_double(RDStation::ErrorHandler)
        allow(error_handler).to receive(:raise_error)
        expect(RDStation::ErrorHandler).to receive(:new).with(response).and_return(error_handler)
        RDStation::ApiResponse.build(response)
      end
    end

    context "when the response is not in the 2xx range" do
      let(:response) { OpenStruct.new(code: 404, body: '{}') }

      it_behaves_like 'call_error_handler'
    end

    context "when the response body is not JSON-parseable" do
      let(:response) { OpenStruct.new(code: 504, body: '<html><head></head><body></body></html>') }

      it "raises no error" do
        expect do
          RDStation::ApiResponse.build(response)
        end.not_to raise_error
      end

      it_behaves_like 'call_error_handler'
    end
  end
end
