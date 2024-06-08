# frozen_string_literal: true

require_relative 'client_error'

module Easyship
  module Errors
    # Raised when Easyship returns the HTTP status code 402
    class PaymentRequiredError < ClientError; end
  end
end
