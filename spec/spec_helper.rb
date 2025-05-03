# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  minimum_coverage 95
end

require 'easyship'

# Load support files
Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    Easyship.configure do |c|
      c.url = 'https://api.easyship.com'
      c.api_key = ENV.fetch('EASYSHIP_API_KEY', nil)
    end
  end
end
