# frozen_string_literal: true

module Easyship
  module RateLimiting
    # Represents RateLimiter
    class RateLimiter
      def throttle!
        raise NotImplementedError
      end
    end
  end
end
