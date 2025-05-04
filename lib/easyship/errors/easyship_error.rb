# frozen_string_literal: true

module Easyship
  module Errors
    # Represents an error that is raised when an error occurs in the Easyship API.
    class EasyshipError < StandardError
      attr_reader :message, :error, :response_body, :response_headers

      def initialize(message: '', body_error: {}, error: {}, response_body: nil, response_headers: {})
        super(message)
        @error = error
        @message = message
        @body_error = body_error
        @response_body = response_body
        @response_headers = response_headers
      end

      def body_error
        warn '[DEPRECATION] `body_error` is deprecated. Please use `error` instead.'
        @body_error
      end
    end
  end
end
