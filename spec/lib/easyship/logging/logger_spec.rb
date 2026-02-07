# frozen_string_literal: true

require 'spec_helper'
require 'logger'
require 'stringio'

RSpec.describe Easyship::Logging::Logger do
  # Create a test class that includes the Logger module
  let(:test_class) do
    Class.new do
      include Easyship::Logging::Logger
    end
  end

  let(:test_instance) { test_class.new }
  let(:log_output) { StringIO.new }
  let(:logger) { Logger.new(log_output) }

  describe '#log_info' do
    it 'logs info message' do
      test_instance.log_info(logger, 'Test info message')

      aggregate_failures do
        expect(log_output.string).to include('[Easyship]')
        expect(log_output.string).to include('INFO')
        expect(log_output.string).to include('Test info message')
      end
    end

    it 'does nothing when logger is nil' do
      expect { test_instance.log_info(nil, 'message') }.not_to raise_error
    end
  end

  describe '#log_debug' do
    it 'logs debug message' do
      logger.level = Logger::DEBUG
      test_instance.log_debug(logger, 'Debug information')

      aggregate_failures do
        expect(log_output.string).to include('[Easyship]')
        expect(log_output.string).to include('DEBUG')
        expect(log_output.string).to include('Debug information')
      end
    end
  end

  describe '#log_warn' do
    it 'logs warning message' do
      test_instance.log_warn(logger, 'Warning message')

      aggregate_failures do
        expect(log_output.string).to include('[Easyship]')
        expect(log_output.string).to include('WARN')
        expect(log_output.string).to include('Warning message')
      end
    end
  end

  describe '#log_request' do
    it 'logs request without sensitive data' do
      test_instance.log_request(logger, :get, '/2023-01/account')

      aggregate_failures do
        log_content = log_output.string
        expect(log_content).to include('[Easyship]')
        expect(log_content).to include('GET')
        expect(log_content).to include('/2023-01/account')
        # Should NOT contain headers, body, or full URL with domain
        expect(log_content).not_to include('Bearer')
        expect(log_content).not_to include('Authorization')
      end
    end

    it 'does nothing when logger is nil' do
      expect do
        test_instance.log_request(nil, :get, '/test')
      end.not_to raise_error
    end
  end

  describe '#log_response' do
    it 'logs successful response (2xx) at debug level' do
      logger.level = Logger::DEBUG
      test_instance.log_response(logger, 200, 0.123)

      aggregate_failures do
        log_content = log_output.string
        expect(log_content).to include('[Easyship]')
        expect(log_content).to include('Response 200')
        expect(log_content).to include('0.123s')
        # Should NOT contain response body or headers
        expect(log_content).not_to include('Body')
        expect(log_content).not_to include('Headers')
      end
    end

    it 'logs client error (4xx) at warn level' do
      test_instance.log_response(logger, 404, nil)

      aggregate_failures do
        expect(log_output.string).to include('WARN')
        expect(log_output.string).to include('Response 404')
      end
    end

    it 'logs server error (5xx) at error level' do
      test_instance.log_response(logger, 500, nil)

      aggregate_failures do
        expect(log_output.string).to include('ERROR')
        expect(log_output.string).to include('Response 500')
      end
    end

    it 'does nothing when logger is nil' do
      expect { test_instance.log_response(nil, 200, 0.1) }.not_to raise_error
    end
  end

  describe '#log_error' do
    let(:error) { StandardError.new('Test error message') }

    before do
      error.set_backtrace(['line 1', 'line 2', 'line 3'])
    end

    it 'logs error with message and context' do
      test_instance.log_error(logger, error, { action: 'fetch_data', id: 123 })

      aggregate_failures do
        log_content = log_output.string
        expect(log_content).to include('ERROR')
        expect(log_content).to include('StandardError')
        expect(log_content).to include('Test error message')
        expect(log_content).to include('Context')
      end
    end

    it 'logs error with backtrace' do
      test_instance.log_error(logger, error)

      aggregate_failures do
        log_content = log_output.string
        expect(log_content).to include('line 1')
        expect(log_content).to include('line 2')
      end
    end

    it 'does nothing when logger is nil' do
      expect { test_instance.log_error(nil, error) }.not_to raise_error
    end
  end
end
