# frozen_string_literal: true

module Easyship
  module RateLimiting
    # Represents WindowRateLimiter
    class WindowRateLimiter < RateLimiter
      attr_reader :timestamps, :requests_per_second, :requests_per_minute

      def initialize(requests_per_second:, requests_per_minute:)
        super()
        @requests_per_second = requests_per_second
        @requests_per_minute = requests_per_minute
        @timestamps = []
      end

      def throttle!
        now = Time.now

        timestamps << now

        # Remove timestamps older than a minute
        timestamps.reject! { |t| t < now - 60 }

        check_second_window(now)
        check_minute_window(now)
      end

      private

      def check_second_window(now)
        second_requests = timestamps.count { |t| t > now - 1 }

        return if !requests_per_second || second_requests < requests_per_second

        first_in_seconds = timestamps.find { |t| t > now - 1 }
        sleep_time = (first_in_seconds + 1) - now

        sleep(sleep_time) if sleep_time.positive?
      end

      def check_minute_window(now)
        return if !requests_per_minute || timestamps.size < requests_per_minute

        sleep_time = (timestamps.first + 60) - now

        sleep(sleep_time) if sleep_time.positive?
      end
    end
  end
end
