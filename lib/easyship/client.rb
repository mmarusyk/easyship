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

    def get(path, params = {}, headers: {}, &block)
      if block
        Easyship::Pagination::Cursor.new(self, path, params).all(&block)
      else
        response = connection(headers).get(path, params)

        handle_response(response)
      end
    end

    def post(path, params = {}, headers: {})
      response = connection(headers).post(path, params.to_json)

      handle_response(response)
    end

    def put(path, params = {}, headers: {})
      response = connection(headers).put(path, params.to_json)

      handle_response(response)
    end

    def delete(path, params = {}, headers: {})
      response = connection(headers).delete(path, params)

      handle_response(response)
    end

    def patch(path, params = {}, headers: {})
      response = connection(headers).patch(path, params.to_json)

      handle_response(response)
    end

    private

    def connection(custom_headers = {})
      Faraday.new(url: @url) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.headers['Authorization'] = "Bearer #{@api_key}"
        faraday.headers['Content-Type'] = 'application/json'
        merge_headers(faraday, custom_headers)
        faraday.use Easyship::Middleware::ErrorHandlerMiddleware
      end
    end

    def merge_headers(faraday, custom_headers)
      # Merge global configuration headers
      Easyship.configuration.headers.each do |key, value|
        faraday.headers[key] = value
      end

      # Merge request-specific headers (override globals)
      custom_headers.each do |key, value|
        faraday.headers[key] = value
      end
    end

    def handle_response(response)
      Easyship::Handlers::ResponseBodyHandler.handle_response(response)
    end
  end
end
