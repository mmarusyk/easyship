# frozen_string_literal: true

require 'singleton'
require 'faraday'
require_relative 'middleware/error_handler_middleware'
require_relative 'handlers/response_body_handler'
require_relative 'pagination/cursor'

module Easyship
  # Represents a client to interact with the Easyship API
  class Client
    include Singleton

    def initialize
      @url = Easyship.configuration.url
      @api_key = Easyship.configuration.api_key
    end

    def get(path, params = {}, &block)
      if block
        Easyship::Pagination::Cursor.new(self, path, params).all(&block)
      else
        response = connection.get(path, params)

        handle_response(response)
      end
    end

    def post(path, params = {})
      response = connection.post(path, params.to_json)

      handle_response(response)
    end

    def put(path, params = {})
      response = connection.put(path, params.to_json)

      handle_response(response)
    end

    def delete(path, params = {})
      response = connection.delete(path, params)

      handle_response(response)
    end

    private

    def connection
      Faraday.new(url: @url) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.headers['Authorization'] = "Bearer #{@api_key}"
        faraday.headers['Content-Type'] = 'application/json'
        faraday.use Easyship::Middleware::ErrorHandlerMiddleware
      end
    end

    def handle_response(response)
      Easyship::Handlers::ResponseBodyHandler.handle_response(response)
    end
  end
end
