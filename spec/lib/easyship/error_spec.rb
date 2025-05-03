# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Easyship::Error do
  describe '.for_status' do
    shared_examples 'returns correct error class' do |status_code, expected_error_class|
      it "returns #{expected_error_class} for status #{status_code}" do
        expect(described_class.for_status(status_code)).to eq(expected_error_class)
      end
    end

    context 'when status code has an error class' do
      {
        400 => Easyship::Errors::BadRequestError,
        401 => Easyship::Errors::InvalidTokenError,
        402 => Easyship::Errors::PaymentRequiredError,
        404 => Easyship::Errors::ResourceNotFoundError,
        422 => Easyship::Errors::UnprocessableContentError,
        429 => Easyship::Errors::RateLimitError
      }.each do |status, error_class|
        it_behaves_like 'returns correct error class', status, error_class
      end
    end

    context 'when 4XX status code does not have an error class' do
      [403, 418].each do |status|
        it_behaves_like 'returns correct error class', status, Easyship::Errors::ClientError
      end
    end

    context 'when 5XX status code does not have an error class' do
      [500, 502, 503].each do |status|
        it_behaves_like 'returns correct error class', status, Easyship::Errors::ServerError
      end
    end

    context 'with other status code does not have an error class' do
      [200, 300].each do |status|
        it 'does not return an error class' do
          expect(described_class.for_status(status)).to be_nil
        end
      end
    end
  end
end
