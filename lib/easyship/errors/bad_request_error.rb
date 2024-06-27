# frozen_string_literal: true

require_relative 'client_error'

module Easyship
  module Errors
    # Raised when Easyship returns the HTTP status code 400
    class BadRequestError < ClientError; end
  end
end
