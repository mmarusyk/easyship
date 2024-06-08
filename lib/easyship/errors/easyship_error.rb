# frozen_string_literal: true

module Easyship
  module Errors
    # Represents an error that is raised when an error occurs in the Easyship API.
    class EasyshipError < StandardError
      attr_reader :message, :body_error

      def initialize(message: '', body_error: {})
        super(message)
        @message = message
        @body_error = body_error
      end
    end
  end
end
