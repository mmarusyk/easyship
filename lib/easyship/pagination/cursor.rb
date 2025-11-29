# frozen_string_literal: true

module Easyship
  module Pagination
    # Represents a pagination object
    class Cursor
      CONFIGURATION_VARIABLES = %i[requests_per_second requests_per_minute].freeze

      attr_reader :client, :path, :params, :key, :per_page, :requests_per_second, :requests_per_minute

      def initialize(client, path, params)
        @client = client
        @path = path
        @params = params
        @per_page = params[:per_page] || Easyship.configuration.per_page
        @requests_per_second = params[:requests_per_second] || Easyship.configuration.requests_per_second
        @requests_per_minute = params[:requests_per_minute] || Easyship.configuration.requests_per_minute
      end

      def all
        page = 1

        loop do
          limiter.throttle!

          body = client.get(path, build_request_params(page: page))

          break if body.nil? || body.empty?

          yield body

          break if body.dig(:meta, :pagination, :next).nil?

          page += 1
        end
      end

      private

      def build_request_params(page:)
        params.merge(page: page, per_page: per_page).except(*CONFIGURATION_VARIABLES)
      end

      def limiter
        @limiter ||= Easyship::RateLimiting::WindowRateLimiter.new(
          requests_per_second: requests_per_second,
          requests_per_minute: requests_per_minute
        )
      end
    end
  end
end
