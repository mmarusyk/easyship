# frozen_string_literal: true

module Easyship
  # Represents the configuration settings for the Easyship client.
  class Configuration
    attr_accessor :url, :api_key

    def initialize
      @url = nil
      @api_key = nil
    end
  end
end
