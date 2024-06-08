# frozen_string_literal: true

Dir[File.join(__dir__, 'errors', '**', '*.rb')].each { |f| require_relative f }

module Easyship
  # Represents a mapping of HTTP status codes to Easyship-specific classes
  class Error
    # rubocop:disable Style::MutableConstant Style::MissingElse
    ERRORS = {
      401 => Easyship::Errors::InvalidTokenError,
      402 => Easyship::Errors::PaymentRequiredError,
      404 => Easyship::Errors::ResourceNotFoundError,
      422 => Easyship::Errors::UnprocessableContentError,
      429 => Easyship::Errors::RateLimitError
    }

    ERRORS.default_proc = proc do |_hash, key|
      case key.to_s
      when /4\d{2}/
        Easyship::Errors::ClientError
      when /5\d{2}/
        Easyship::Errors::ServerError
      end
    end
    # rubocop:enable Style::MutableConstant Style::MissingElse

    ERRORS.freeze
  end
end
