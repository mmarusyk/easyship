# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Easyship::Client do
  subject(:client) { described_class.instance }

  describe '#get' do
    let(:path) { '/2023-01/account' }

    it 'returns account information' do
      VCR.use_cassette('accounts') do
        expect(client.get(path)).to be_a(Hash)
      end
    end

    context 'when block passed' do
      let(:path) { '/2023-01/countries' }
      let(:expected_items) { 249 } # Total items in the cassette

      let(:params) do
        {
          per_page: 100,
          requests_per_second: 10,
          requests_per_minute: 60
        }
      end

      it 'returns all countries' do
        VCR.use_cassette('countries') do
          countries = []

          client.get(path) { |page| countries += page[:countries] }

          expect(countries.count).to eq(expected_items)
        end
      end
    end

    context 'when raise any error' do
      it 'contains necessary attributes' do
        VCR.use_cassette('invalid_token') do
          client.get(path)
        rescue Easyship::Errors::InvalidTokenError => e
          expect(e).to respond_to(:message)
            .and respond_to(:body_error)
            .and respond_to(:response_body)
            .and respond_to(:response_headers)
        end
      end
    end

    context 'when invalid api_key' do
      it 'raises an InvalidTokenError' do
        VCR.use_cassette('invalid_token') do
          expect { client.get(path) }.to raise_error(Easyship::Errors::InvalidTokenError)
        end
      end
    end

    context 'when the path is invalid' do
      let(:path) { '/2023-01/invalid-path' }

      it 'raises a ResourceNotFoundError' do
        VCR.use_cassette('invalid_path') do
          expect { client.get(path) }.to raise_error(Easyship::Errors::ResourceNotFoundError)
        end
      end
    end

    context 'when internal server error' do
      it 'raises an ServerError' do
        VCR.use_cassette('server_error') do
          expect { client.get(path) }.to raise_error(Easyship::Errors::ServerError)
        end
      end
    end

    context 'when rate limit error' do
      let(:path) { '/2024-09/countries' }

      it 'raises an RateLimitError' do
        VCR.use_cassette('rate_limit_error') do
          expect { client.get(path) }.to raise_error(Easyship::Errors::RateLimitError)
        end
      end
    end
  end

  describe '#post' do
    let(:path) { '/rate/v1/rates' }

    context 'when invalid request body' do
      it 'raises a ClientError' do
        VCR.use_cassette('rate/v1/rates/invalid-body') do
          expect { client.post(path, {}) }.to raise_error(Easyship::Errors::BadRequestError)
        end
      end
    end
  end
end
