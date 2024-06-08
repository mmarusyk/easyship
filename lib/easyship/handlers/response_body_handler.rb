# frozen_string_literal: true

module Easyship
  module Handlers
    # Handles the response body
    class ResponseBodyHandler
      def self.handle_response(response)
        body = response.body

        JSON.parse(body, symbolize_names: true) unless body.nil? || body.empty?
      end
    end
  end
end
