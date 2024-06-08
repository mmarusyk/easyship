# frozen_string_literal: true

require_relative 'easyship_error'

module Easyship
  module Errors
    # Raised when Easyship returns a 4xx HTTP status code
    class ClientError < EasyshipError; end
  end
end
