# frozen_string_literal: true

require_relative 'easyship/version'
require_relative 'easyship/configuration'
require_relative 'easyship/client'

# Provides configuration options for the Easyship gem.
module Easyship
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
