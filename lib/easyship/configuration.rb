# frozen_string_literal: true

require_relative 'logging/null_logger'

module Easyship
  # Represents the configuration settings for the Easyship client.
  class Configuration
    attr_accessor :url, :api_key, :per_page, :requests_per_second, :requests_per_minute, :headers, :logger

    def initialize
      @url = nil
      @api_key = nil
      @per_page = 100 # Maximum possible number of items per page
      @requests_per_second = nil
      @requests_per_minute = nil
      @headers = {}
      @logger = Easyship::Logging::NullLogger.new
    end
  end
end
