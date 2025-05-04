# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Easyship::Errors::EasyshipError do
  subject(:easyship_error) { described_class.new(body_error: body_error) }

  let(:body_error) { { details: [], message: 'Something went wrong' } }

  describe '#body_error' do
    it 'outputs a deprecation warning' do
      expect { easyship_error.body_error }.to output(/\[DEPRECATION\] `body_error` is deprecated/).to_stderr
    end

    it 'returns the body_error value' do
      expect(easyship_error.body_error).to eq(body_error)
    end
  end
end
