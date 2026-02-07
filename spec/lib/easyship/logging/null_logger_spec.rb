# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Easyship::Logging::NullLogger do
  subject(:logger) { described_class.new }

  describe 'logging methods' do
    it 'responds to debug without output' do
      expect { logger.debug('test message') }.not_to output.to_stdout
    end

    it 'responds to info without output' do
      expect { logger.info('test message') }.not_to output.to_stdout
    end

    it 'responds to warn without output' do
      expect { logger.warn('test message') }.not_to output.to_stdout
    end

    it 'responds to error without output' do
      expect { logger.error('test message') }.not_to output.to_stdout
    end

    it 'responds to fatal without output' do
      expect { logger.fatal('test message') }.not_to output.to_stdout
    end

    it 'responds to unknown without output' do
      expect { logger.unknown('test message') }.not_to output.to_stdout
    end
  end

  describe '#level' do
    it 'returns UNKNOWN level' do
      expect(logger.level).to eq(Logger::UNKNOWN)
    end

    it 'accepts level assignment without error' do
      expect { logger.level = Logger::DEBUG }.not_to raise_error
    end
  end

  describe '#tagged' do
    it 'yields self when block given' do
      expect { |b| logger.tagged('tag', &b) }.to yield_with_args(logger)
    end

    it 'works without block' do
      expect { logger.tagged('tag') }.not_to raise_error
    end
  end

  describe '#formatter' do
    it 'returns nil' do
      expect(logger.formatter).to be_nil
    end

    it 'accepts formatter assignment without error' do
      expect { logger.formatter = proc {} }.not_to raise_error
    end
  end
end
