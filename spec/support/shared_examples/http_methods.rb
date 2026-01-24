# frozen_string_literal: true

RSpec.shared_examples 'HTTP method with custom headers' do |method, cassette, error_class|
  # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
  it "sends custom headers with #{method.upcase} request" do
    VCR.use_cassette(cassette) do
      expectation = case method
                    when :get
                      expect(client.get(path, {}, headers: custom_headers))
                    when :post
                      expect { client.post(path, payload, headers: custom_headers) }
                    when :put
                      expect { client.put(path, payload, headers: custom_headers) }
                    when :patch
                      expect { client.patch(path, payload, headers: custom_headers) }
                    when :delete
                      expect { client.delete(path, {}, headers: custom_headers) }
                    end

      if error_class
        expectation.to raise_error(error_class)
      else
        expectation.to be_a(Hash)
      end
    end
  end
  # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
end
