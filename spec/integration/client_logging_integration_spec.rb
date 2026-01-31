# frozen_string_literal: true

require 'spec_helper'
require 'logger'
require 'stringio'

RSpec.describe Easyship::Client do
  describe 'logging integration' do
    let(:log_output) { StringIO.new }
    let(:custom_logger) do
      logger = Logger.new(log_output)
      logger.level = Logger::DEBUG
      logger
    end

    before do
      # Reinitialize the singleton with new logger configuration
      described_class.instance_variable_set(:@singleton__instance__, nil)

      Easyship.configure do |config|
        config.url = 'https://api.easyship.com'
        config.api_key = ENV.fetch('EASYSHIP_API_KEY', nil)
        config.logger = custom_logger
      end
    end

    after do
      # Reset to default NullLogger
      described_class.instance_variable_set(:@singleton__instance__, nil)

      Easyship.configure do |config|
        config.logger = Easyship::Logging::NullLogger.new
      end
    end

    describe 'GET requests' do
      it 'logs request and response' do
        VCR.use_cassette('accounts') do
          described_class.instance.get('/2023-01/account')

          aggregate_failures 'logging output' do
            log_content = log_output.string
            expect(log_content).to include('[Easyship]')
            expect(log_content).to include('GET')
            expect(log_content).to include('/2023-01/account')
            expect(log_content).to include('Response')
          end
        end
      end

      it 'does not log sensitive data' do
        VCR.use_cassette('accounts') do
          described_class.instance.get('/2023-01/account')

          aggregate_failures 'no sensitive data' do
            log_content = log_output.string
            expect(log_content).not_to include('Bearer', 'Authorization', 'api_key', 'Body:', 'Headers:')
          end
        end
      end

      it 'logs request duration' do
        VCR.use_cassette('accounts') do
          described_class.instance.get('/2023-01/account')

          expect(log_output.string).to match(/\d+\.\d{3}s/)
        end
      end
    end

    describe 'error logging' do
      it 'logs error class and message' do
        VCR.use_cassette('invalid_token') do
          aggregate_failures do
            expect { described_class.instance.get('/2023-01/account') }
              .to raise_error(Easyship::Errors::InvalidTokenError)

            log_content = log_output.string
            expect(log_content).to include('ERROR')
            expect(log_content).to include('InvalidTokenError')
            expect(log_content).to include('Context')
          end
        end
      end

      it 'does not log API key in errors' do
        next unless ENV['EASYSHIP_API_KEY']

        VCR.use_cassette('invalid_token') do
          aggregate_failures do
            expect { described_class.instance.get('/2023-01/account') }
              .to raise_error(Easyship::Errors::InvalidTokenError)

            expect(log_output.string).not_to include(ENV.fetch('EASYSHIP_API_KEY'))
          end
        end
      end
    end
  end
end
