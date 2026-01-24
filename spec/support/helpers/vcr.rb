# frozen_string_literal: true

require 'vcr'
require_relative '../../../lib/easyship'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = false
  config.ignore_localhost = true
  config.filter_sensitive_data('<API_KEY>') { Easyship.configuration.api_key }

  config.register_request_matcher :custom_header do |r1, r2|
    headers_to_match = %w[X-Custom-Header X-Custom-Global X-Override-Test
                          X-Request-Id X-Idempotency-Key]
    headers_to_match.all? { |header| r1.headers[header] == r2.headers[header] }
  end

  config.default_cassette_options = {
    match_requests_on: %i[method uri body custom_header]
  }
end
