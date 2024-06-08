# frozen_string_literal: true

require_relative 'client_error'

module Easyship
  module Errors
    # Raised when Easyship returns the HTTP status code 422
    class UnprocessableContentError < ClientError; end
  end
end
