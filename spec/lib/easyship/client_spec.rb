# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Easyship::Client do
  subject(:client) { described_class.instance }

  describe '#get' do
    let(:path) { '/2023-01/account' }

    context 'with successful response' do
      it 'returns account information as a Hash' do
        VCR.use_cassette('accounts') do
          expect(client.get(path)).to be_a(Hash)
        end
      end
    end

    context 'with pagination block' do
      let(:path) { '/2023-01/countries' }
      let(:expected_items) { 249 }
      let(:params) do
        {
          per_page: 100,
          requests_per_second: 10,
          requests_per_minute: 60
        }
      end

      it 'yields pages and returns all items' do
        VCR.use_cassette('countries') do
          countries = []

          client.get(path) { |page| countries += page[:countries] }

          expect(countries.count).to eq(expected_items)
        end
      end
    end

    context 'with error responses' do
      context 'when API key is invalid' do
        let(:error) do
          VCR.use_cassette('invalid_token') do
            client.get(path)
          rescue Easyship::Errors::InvalidTokenError => e
            e
          end
        end

        it 'raises InvalidTokenError' do
          VCR.use_cassette('invalid_token') do
            expect { client.get(path) }.to raise_error(Easyship::Errors::InvalidTokenError)
          end
        end

        it_behaves_like 'an error with standard attributes'
      end

      context 'when path is invalid' do
        let(:path) { '/2023-01/invalid-path' }

        it 'raises ResourceNotFoundError' do
          VCR.use_cassette('invalid_path') do
            expect { client.get(path) }.to raise_error(Easyship::Errors::ResourceNotFoundError)
          end
        end
      end

      context 'when internal server error occurs' do
        it 'raises ServerError' do
          VCR.use_cassette('server_error') do
            expect { client.get(path) }.to raise_error(Easyship::Errors::ServerError)
          end
        end
      end

      context 'when rate limit is exceeded' do
        let(:path) { '/2024-09/countries' }

        it 'raises RateLimitError' do
          VCR.use_cassette('rate_limit_error') do
            expect { client.get(path) }.to raise_error(Easyship::Errors::RateLimitError)
          end
        end
      end
    end
  end

  describe '#post' do
    let(:path) { '/rate/v1/rates' }

    context 'with invalid request body' do
      it 'raises BadRequestError' do
        VCR.use_cassette('rate/v1/rates/invalid-body') do
          expect { client.post(path, {}) }.to raise_error(Easyship::Errors::BadRequestError)
        end
      end
    end
  end

  describe 'custom headers support' do
    let(:path) { '/2023-01/account' }

    describe 'global headers via configuration' do
      include_context 'with global custom headers'

      it 'includes global headers in GET requests' do
        VCR.use_cassette('custom_headers/global_headers_get') do
          response = client.get(path)
          expect(response).to be_a(Hash)
        end
      end

      it 'includes global headers in POST requests' do
        VCR.use_cassette('custom_headers/global_headers_post') do
          payload = {
            origin_country_alpha2: 'SG',
            destination_country_alpha2: 'US'
          }

          expect { client.post('/2023-01/shipments', payload) }
            .to raise_error(Easyship::Errors::BadRequestError)
        end
      end
    end

    describe 'per-request headers' do
      let(:custom_headers) { { 'X-Request-ID' => 'unique-request-id-123' } }
      let(:payload) { {} }

      context 'with GET request' do
        it_behaves_like 'HTTP method with custom headers', :get, 'custom_headers/per_request_get', nil
      end

      context 'with POST request and idempotency key' do
        let(:path) { '/2023-01/shipments' }
        let(:custom_headers) { { 'X-Idempotency-Key' => 'test-idempotency-key-12345' } }
        let(:payload) do
          {
            origin_country_alpha2: 'SG',
            destination_country_alpha2: 'US',
            tax_paid_by: 'Recipient',
            is_insured: false,
            items: [
              {
                description: 'Test item',
                actual_weight: 1.0,
                declared_currency: 'USD',
                declared_customs_value: 100
              }
            ]
          }
        end

        it_behaves_like 'HTTP method with custom headers', :post, 'custom_headers/post_with_idempotency',
                        Easyship::Errors::BadRequestError
      end

      context 'with PUT request' do
        let(:path) { '/2023-01/shipments/test-id' }
        let(:custom_headers) { { 'X-Custom-Header' => 'custom-value' } }
        let(:payload) { { status: 'updated' } }

        it_behaves_like 'HTTP method with custom headers', :put, 'custom_headers/put_with_headers',
                        Easyship::Errors::ResourceNotFoundError
      end

      context 'with PATCH request' do
        let(:path) { '/2023-01/shipments/test-id' }
        let(:custom_headers) { { 'X-Custom-Header' => 'patch-value' } }
        let(:payload) { { status: 'patched' } }

        it_behaves_like 'HTTP method with custom headers', :patch, 'custom_headers/patch_with_headers',
                        Easyship::Errors::ResourceNotFoundError
      end

      context 'with DELETE request' do
        let(:path) { '/2023-01/shipments/test-id' }
        let(:custom_headers) { { 'X-Custom-Header' => 'delete-value' } }

        it_behaves_like 'HTTP method with custom headers', :delete, 'custom_headers/delete_with_headers',
                        Easyship::Errors::ResourceNotFoundError
      end
    end

    describe 'header override behavior' do
      let(:override_header_key) { 'X-Override-Test' }

      before do
        Easyship.configure do |config|
          config.headers = { override_header_key => 'global-value' }
        end
      end

      after do
        Easyship.configure do |config|
          config.headers = {}
        end
      end

      it 'allows per-request headers to override global configuration' do
        VCR.use_cassette('custom_headers/header_override') do
          response = client.get(path, {}, headers: { override_header_key => 'request-value' })
          expect(response).to be_a(Hash)
        end
      end
    end
  end
end
