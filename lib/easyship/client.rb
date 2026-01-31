# frozen_string_literal: true

require 'singleton'
require 'faraday'
require_relative 'middleware/error_handler_middleware'
require_relative 'handlers/response_body_handler'
require_relative 'pagination/cursor'
require_relative 'logging/logger'

module Easyship
  # Represents a client to interact with the Easyship API
  class Client
    include Singleton
    include Easyship::Logging::Logger

    def initialize
      @url = Easyship.configuration.url
      @api_key = Easyship.configuration.api_key
      @logger = Easyship.configuration.logger
    end

    def get(path, params = {}, headers: {}, &block)
      if block
        Easyship::Pagination::Cursor.new(self, path, params).all(&block)
      else
        execute_request(:get, path, params, headers) do |conn|
          conn.get(path, params)
        end
      end
    end

    def post(path, params = {}, headers: {})
      execute_request(:post, path, params, headers) do |conn|
        conn.post(path, params.to_json)
      end
    end

    def put(path, params = {}, headers: {})
      execute_request(:put, path, params, headers) do |conn|
        conn.put(path, params.to_json)
      end
    end

    def delete(path, params = {}, headers: {})
      execute_request(:delete, path, params, headers) do |conn|
        conn.delete(path, params)
      end
    end

    def patch(path, params = {}, headers: {})
      execute_request(:patch, path, params, headers) do |conn|
        conn.patch(path, params.to_json)
      end
    end

    private

    def execute_request(method, path, _params, headers)
      log_request(@logger, method, path)

      start_time = Time.now
      response = yield(connection(headers))
      duration = Time.now - start_time

      log_response(@logger, response.status, duration)

      handle_response(response)
    rescue StandardError => e
      log_error(@logger, e, { method: method, path: path })
      raise
    end

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
