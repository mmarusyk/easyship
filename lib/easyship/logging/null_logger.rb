# frozen_string_literal: true

module Easyship
  module Logging
    # Implements the standard Logger interface but performs no actual logging,
    # making it safe to use as a default without any output or performance impact.
    class NullLogger
      def debug(_message = nil, &); end

      def info(_message = nil, &); end

      def warn(_message = nil, &); end

      def error(_message = nil, &); end

      def fatal(_message = nil, &); end

      def unknown(_message = nil, &); end

      def level=(_level); end

      def level
        ::Logger::UNKNOWN
      end

      def tagged(*_tags)
        yield self if block_given?
      end

      def formatter=(_formatter); end

      def formatter
        nil
      end
    end
  end
end
