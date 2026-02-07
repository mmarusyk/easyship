# frozen_string_literal: true

require 'logger'

module Easyship
  module Logging
    # This module provides logging methods that can be included in any class
    # to add secure, standardized logging capabilities.
    module Logger
      def log_info(logger, message)
        return unless logger

        logger.info("[Easyship] #{message}")
      end

      def log_debug(logger, message)
        return unless logger

        logger.debug("[Easyship] #{message}")
      end

      def log_warn(logger, message)
        return unless logger

        logger.warn("[Easyship] #{message}")
      end

      def log_error(logger, error, context = {})
        return unless logger

        logger.error do
          message = "[Easyship] Error: #{error.class} - #{error.message}"
          message += " | Context: #{context}" if context.any?
          message += "\n#{error.backtrace.join("\n")}" if error.backtrace
          message
        end
      end

      def log_request(logger, method, path)
        return unless logger

        logger.info("[Easyship] #{method.to_s.upcase} #{path}")
      end

      def log_response(logger, status, duration = nil)
        return unless logger

        level = response_log_level(status)
        message = "[Easyship] Response #{status}"
        message += " (#{format('%.3f', duration)}s)" if duration

        logger.public_send(level, message)
      end

      private

      def response_log_level(status)
        return :warn if status.between?(400, 499)
        return :error if status.between?(500, 599)
        return :debug if status.between?(200, 299)

        :info
      end
    end
  end
end
