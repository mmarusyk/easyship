# frozen_string_literal: true

module Easyship
  module Handlers
    # Handles the response body
    class ResponseBodyHandler
      def self.handle_response(response)
        JSON.parse(response.body, symbolize_names: true)
      rescue JSON::ParserError
        response.body
      end
    end
  end
end
