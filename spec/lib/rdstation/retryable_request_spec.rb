require 'spec_helper'

class DummyClass
  include ::RDStation::RetryableRequest
end

RSpec.describe RDStation::RetryableRequest do
  let(:subject) { DummyClass.new }
  describe '.retryable_request' do
    context 'when authorization has a valid refresh_token and config is provided' do
      let (:access_token) { 'access_token' }
      let (:new_access_token) { 'new_access_token' }
      let (:refresh_token) { 'refresh_token' }
      let (:auth) do
         ::RDStation::Authorization.new(access_token: access_token, 
                                        refresh_token: refresh_token
                                        )
      end
      context 'original request was successful' do
        it 'yields control to the given block' do
          expect do |block|
            subject.retryable_request(auth, &block)
          end.to yield_with_args(auth)
        end
      end

      context 'original request raised a retryable exception' do
        let (:auth_new_access_token) do
          ::RDStation::Authorization.new(access_token: new_access_token, 
                                         refresh_token: refresh_token
                                         )
        end 

        let(:new_credentials) do
          {
            'access_token' => new_access_token,
            'expires_in' => 86_400,
            'refresh_token' => refresh_token
          }
        end
        let(:authentication_client) {instance_double(::RDStation::Authentication) }

        before do
          RDStation.configure do |config|
            config.client_id = "123"
            config.client_secret = "312"
            config.on_access_token_refresh do
              'callback code'
            end
          end
          allow(::RDStation::Authentication).to receive(:new)
                                            .with(no_args)
                                            .and_return(authentication_client)
          allow(authentication_client).to receive(:update_access_token)
                                            .with(auth.refresh_token).
                                            and_return(new_credentials)
        end

        it 'refreshes the access_token and retries the request' do
          dummy_request = double("dummy_request")
          expect(dummy_request).to receive(:call).twice do |auth|
            expired_token = ::RDStation::Error::ExpiredAccessToken.new({'error_message' => 'x'})
            raise expired_token unless auth.access_token == new_access_token
          end
        
          expect(RDStation.configuration.access_token_refresh_callback)
            .to receive(:call)
            .once do |authorization|
              expect(authorization.access_token).to eq new_access_token
            end

          expect do
            subject.retryable_request(auth) { |yielded_auth| dummy_request.call(yielded_auth) }
          end.not_to raise_error
        end

        context 'and keeps raising retryable exception event after token refreshed' do
          it 'retries only once' do
            dummy_request = double("dummy_request")
            expect(dummy_request).to receive(:call).twice do |_|
              raise ::RDStation::Error::ExpiredAccessToken.new({'error_message' => 'x'})
            end
          
            expect do
              subject.retryable_request(auth) { |yielded_auth| dummy_request.call(yielded_auth) }
            end.to raise_error ::RDStation::Error::ExpiredAccessToken
          end
        end

        context 'and access token refresh callback is not set' do
          before do
            RDStation.configure do |config|
              config.on_access_token_refresh(&nil)
            end
          end

          it 'executes the refresh and retry without raising an error' do
            dummy_request = double("dummy_request")
            expect(dummy_request).to receive(:call).twice do |auth|
              expired_token = ::RDStation::Error::ExpiredAccessToken.new({'error_message' => 'x'})
              raise expired_token unless auth.access_token == new_access_token
            end

            expect do
              subject.retryable_request(auth) { |yielded_auth| dummy_request.call(yielded_auth) }
            end.not_to raise_error
          end
        end
      end

      context 'original request raised a non retryable exception' do
        it 'raises error' do
          dummy_request = double("dummy_request")
          expect(dummy_request).to receive(:call).once do |_|
            raise RuntimeError.new("a non retryable error")
          end
        
          expect do
            subject.retryable_request(auth) { |yielded_auth| dummy_request.call(yielded_auth) }
          end.to raise_error RuntimeError
        end
      end
    end

    context 'all legacy scenarios' do
      let (:access_token) { 'access_token' }
      let (:auth) { ::RDStation::Authorization.new(access_token: access_token) }

      it 'implement me' do
        dummy_request = double("dummy_request")
        expect(dummy_request).to receive(:call).once do |_|
          raise ::RDStation::Error::ExpiredAccessToken.new({'error_message' => 'x'})
        end
      
        expect do
          subject.retryable_request(auth) { |yielded_auth| dummy_request.call(yielded_auth) }
        end.to raise_error ::RDStation::Error::ExpiredAccessToken
      end
    end

  end
end
