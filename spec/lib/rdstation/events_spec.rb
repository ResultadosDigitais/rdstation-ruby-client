require 'spec_helper'

RSpec.describe RDStation::Events do
  let(:valid_auth_token) { 'valid_auth_token' }
  let(:invalid_auth_token) { 'invalid_auth_token' }
  let(:expired_auth_token) { 'expired_auth_token' }

  let(:event_with_valid_token) { described_class.new(valid_auth_token) }
  let(:event_with_expired_token) { described_class.new(expired_auth_token) }
  let(:event_with_invalid_token) { described_class.new(invalid_auth_token) }

  let(:events_endpoint) { 'https://api.rd.services/platform/events' }

  let(:valid_headers) do
    {
      'Authorization' => "Bearer #{valid_auth_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:invalid_token_headers) do
    {
      'Authorization' => "Bearer #{invalid_auth_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:expired_token_headers) do
    {
      'Authorization' => "Bearer #{expired_auth_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:invalid_token_response) do
    {
      status: 401,
      body: {
        errors: {
          error_type: 'UNAUTHORIZED',
          error_message: 'Invalid token.'
        }
      }.to_json
    }
  end

  let(:expired_token_response) do
    {
      status: 401,
      headers: { 'WWW-Authenticate' => 'Bearer realm="https://api.rd.services/", error="expired_token", error_description="The access token expired"' },
      body: {
        errors: {
          error_type: 'UNAUTHORIZED',
          error_message: 'Invalid token.'
        }
      }.to_json
    }
  end

  describe '#create' do
    let(:event) do
      {
        'event_type' => 'OPPORTUNITY_LOST',
        'event_family' => 'CDP',
        'payload' => {
          'email' => 'email@email.com',
          'funnel_name' => 'default',
          'reason' => 'Lost reason'
        }
      }
    end

    context 'with a valid auth token' do
      before do
        stub_request(:post, events_endpoint)
          .with(headers: valid_headers)
          .to_return(status: 200, body: event.to_json)
      end

      it 'returns the event uuid' do
        # {"event_uuid":"830eacd4-6859-43b5-82ef-d2989db38604"}
        response = event_with_valid_token.create(event)
        expect(response).to eq(event)
      end
    end

    context 'with an invalid auth token' do
      before do
        stub_request(:post, events_endpoint)
          .with(headers: invalid_token_headers)
          .to_return(invalid_token_response)
      end

      it 'raises an invalid token error' do
        expect do
          event_with_invalid_token.create(event)
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end

    context 'with an expired auth token' do
      before do
        stub_request(:post, events_endpoint)
          .with(headers: expired_token_headers)
          .to_return(expired_token_response)
      end

      it 'raises a expired token error' do
        expect do
          event_with_expired_token.create(event)
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end

    context 'when the event type is incorrect' do
      # [{"error_type":"INVALID_OPTION","error_message":"Must be one of the valid options.","validation_rules":{"valid_options":["OPPORTUNITY_LOST","EMAIL_DELIVERED","DOUBLE_OPT_IN_EMAIL_CONFIRMED","OPPORTUNITY","CART_ABANDONED_ITEM","FUNNEL_STAGE_CHANGED","MEDIA_PLAYBACK_STOPPED","CONVERSION","MEDIA_PLAYBACK_STARTED","SALE","WORKFLOW_STARTED","EMAIL_SPAM_REPORTED","ORDER_PLACED","EMAIL_SOFT_BOUNCED","CART_ABANDONED","EMAIL_OPENED","EMAIL_DROPPED","EMAIL_HARD_BOUNCED","WORKFLOW_FINISHED","WORKFLOW_CANCELED","EMAIL_CLICKED","ORDER_PLACED_ITEM","CHAT_STARTED","CHAT_FINISHED","EMAIL_UNSUBSCRIBED","PAGE_VISITED","CALL_FINISHED"]},"path":"$.event_type"}]
    end
  end
end
