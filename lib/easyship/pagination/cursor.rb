# frozen_string_literal: true

module Easyship
  module Pagination
    # Represents a pagination object
    class Cursor
      attr_reader :client, :path, :params, :key, :per_page

      def initialize(client, path, params)
        @client = client
        @path = path
        @params = params
        @per_page = params[:per_page] || Easyship.configuration.per_page
      end

      def all
        page = 1

        loop do
          body = client.get(path, params.merge(page: page, per_page: per_page))

          break if body.nil? || body.empty?

          yield body

          break if body.dig(:meta, :pagination, :next).nil?

          page += 1
        end
      end
    end
  end
end
