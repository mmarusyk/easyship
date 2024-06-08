# frozen_string_literal: true

require_relative 'easyship_error'

module Easyship
  module Errors
    # Raised when Easyship returns a 5xx HTTP status code
    class ServerError < EasyshipError; end
  end
end
