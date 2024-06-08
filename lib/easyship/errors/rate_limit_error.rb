# frozen_string_literal: true

require_relative 'client_error'

module Easyship
  module Errors
    # Raised when Easyship returns the HTTP status code 429
    class RateLimitError < ClientError; end
  end
end
