# frozen_string_literal: true

require_relative '../error'
module Easyship
  module Middleware
    # Response middleware that raises an error based on the response status code
    class ErrorHandlerMiddleware < Faraday::Middleware
      def on_complete(env)
        status_code = env[:status].to_i
        body = JSON.parse(env[:body], symbolize_names: true) if json?(env[:body])

        handle_status_code(status_code, body)
      end

      private

      def handle_status_code(status_code, body)
        error_class = Easyship::Error::ERRORS[status_code]

        raise_error(error_class, body) if error_class
      end

      def raise_error(class_error, body)
        raise class_error.new(message: message(body), body_error: body_error(body))
      end

      def body_error(body)
        body.is_a?(Hash) ? body[:error] : {}
      end

      def message(body)
        body.is_a?(Hash) ? body[:error][:message] : body
      end

      def json?(body)
        !body.nil? && body.is_a?(String)
      end
    end
  end
end
