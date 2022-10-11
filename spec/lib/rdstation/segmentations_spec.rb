require 'spec_helper'

RSpec.describe RDStation::Segmentations do
  let(:segmentations_client) do
    described_class.new(authorization: RDStation::Authorization.new(access_token: 'access_token'))
  end

  let(:segmentations_endpoint) { 'https://api.rd.services/platform/segmentations/' }

  let(:headers) do
    {
      Authorization: 'Bearer access_token',
      'Content-Type': 'application/json'
    }
  end

  let(:error_handler) do
    instance_double(RDStation::ErrorHandler, raise_error: 'mock raised errors')
  end

  before do
    allow(RDStation::ErrorHandler).to receive(:new).and_return(error_handler)
  end

  describe '#all' do
    it 'calls retryable_request' do
      expect(segmentations_client).to receive(:retryable_request)
      segmentations_client.all
    end

    context 'when the request is successful' do
      let(:segmentations) do
        {
          segmentations: [
            {
              id: 1,
              name: 'Todos os contatos da base',
              standard: true,
              created_at: '2021-09-24T14:14:04.510-03:00',
              updated_at: '2021-09-24T14:14:04.510-03:00',
              process_status: 'processed',
              links: [
                {
                  rel: 'SELF',
                  href: 'https://api.rd.services/platform/segmentations/1/contacts',
                  media: 'application/json',
                  type: 'GET'
                }
              ]
            }
          ]
        }.to_json
      end

      before do
        stub_request(:get, segmentations_endpoint)
          .with(headers: headers)
          .to_return(status: 200, body: segmentations.to_json)
      end

      it 'returns all segmentations' do
        response = segmentations_client.all
        expect(response).to eq(segmentations)
      end
    end

    context 'when the response contains errors' do
      before do
        stub_request(:get, segmentations_endpoint)
          .with(headers: headers)
          .to_return(status: 400, body: { 'errors' => ['all errors'] }.to_json)
      end

      it 'calls raise_error on error handler' do
        segmentations_client.all
        expect(error_handler).to have_received(:raise_error)
      end
    end
  end

  describe '#contacts' do
    let(:segmentation_id) { 123 }
    let(:segmentations_endpoint_by_contacts) { segmentations_endpoint + "#{segmentation_id}/contacts" }

    it 'calls retryable_request' do
      expect(segmentations_client).to receive(:retryable_request)
      segmentations_client.contacts(segmentation_id)
    end

    context 'when the request is successful' do
      let(:contact) do
        {
          contacts: [
            {
              uuid: '5408c5a3-4711-4f2e-8d0b-13407a3e30f3',
              name: 'Lead Example 1',
              email: 'leadexample1@example.com',
              last_conversion_date: '2021-09-13T15:01:06.325-03:00',
              created_at: '2021-09-13T15:01:06.325-03:00',
              links: [
                {
                  rel: 'SELF',
                  href: 'https://api.rd.services/platform/contacts/5408c5a3-4711-4f2e-8d0b-13407a3e30f3',
                  media: 'application/json',
                  type: 'GET'
                }
              ]
            }
          ]
        }.to_json
      end

      before do
        stub_request(:get, segmentations_endpoint_by_contacts)
          .with(headers: headers)
          .to_return(status: 200, body: contact.to_json)
      end

      it 'returns the contact' do
        response = segmentations_client.contacts(segmentation_id)
        expect(response).to eq(contact)
      end
    end

    context 'when the response contains errors' do
      before do
        stub_request(:get, segmentations_endpoint_by_contacts)
          .with(headers: headers)
          .to_return(status: 400, body: { 'errors' => ['all errors'] }.to_json)
      end

      it 'calls raise_error on error handler' do
        segmentations_client.contacts(segmentation_id)
        expect(error_handler).to have_received(:raise_error)
      end
    end
  end
end
