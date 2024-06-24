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
        return {} unless body.is_a?(Hash)

        if body.key?(:error) && body[:error].is_a?(Hash)
          format_body_error(body)
        elsif body.key?(:errors) && body[:errors].is_a?(Array)
          format_body_errors_array(body)
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

      def format_body_errors_array(body)
        { details: body[:errors], message: body[:errors].map { |error| error[:message] }.join(', ') }
      end

      def format_body_errors(body)
        { details: body[:errors], message: body[:errors] }
      end

      def format_by_default(body)
        { details: body, message: 'Something went wrong.' }
      end

      def json?(body)
        !body.nil? && body.is_a?(String)
      end
    end
  end
end
