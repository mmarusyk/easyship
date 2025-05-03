# frozen_string_literal: true

Dir[File.join(__dir__, 'errors', '**', '*.rb')].each { |f| require_relative f }

module Easyship
  # Represents a mapping of HTTP status codes to Easyship-specific classes
  class Error
    class << self
      def for_status(status_code)
        ERRORS[status_code] || default_error_for(status_code)
      end

      private

      def default_error_for(status_code)
        case status_code.to_s
        when /4\d{2}/
          Easyship::Errors::ClientError
        when /5\d{2}/
          Easyship::Errors::ServerError
        end
      end
    end

    ERRORS = {
      400 => Easyship::Errors::BadRequestError,
      401 => Easyship::Errors::InvalidTokenError,
      402 => Easyship::Errors::PaymentRequiredError,
      404 => Easyship::Errors::ResourceNotFoundError,
      422 => Easyship::Errors::UnprocessableContentError,
      429 => Easyship::Errors::RateLimitError
    }.freeze
  end
end
