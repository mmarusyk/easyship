# frozen_string_literal: true

require_relative '../error'

module Easyship
  module Middleware
    # Response middleware that raises an error based on the response status code
    class ErrorHandlerMiddleware < Faraday::Middleware
      def on_complete(env)
        status_code = env[:status].to_i
        body = response_body(env[:body])

        handle_status_code(status_code, body)
      end

      private

      def handle_status_code(status_code, body)
        error_class = Easyship::Error.for_status(status_code)

        raise_error(error_class, body) if error_class
      end

      def raise_error(class_error, body)
        raise class_error.new(message: message(body), body_error: body_error(body))
      end

      def body_error(body)
        return {} unless body.is_a?(Hash)

        if body.key?(:error) && body[:error].is_a?(Hash)
          format_body_error(body)
        elsif body.key?(:errors)
          format_body_errors(body)
        else
          format_by_default(body)
        end
      end

      def message(body)
        body_error(body)[:message]
      end

      def format_body_error(body)
        body[:error]
      end

      def format_body_errors(body)
        errors = Array(body[:errors])

        { details: errors, message: errors.join(', ') }
      end

      def format_by_default(body)
        { details: body, message: 'Something went wrong.' }
      end

      def response_body(body)
        JSON.parse(body, symbolize_names: true)
      rescue JSON::ParserError
        nil
      end
    end
  end
end
