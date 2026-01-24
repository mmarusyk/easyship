# frozen_string_literal: true

RSpec.shared_context 'with global custom headers' do
  let(:global_headers) do
    {
      'X-Custom-Global' => 'global-value'
    }
  end

  before do
    Easyship.configure do |config|
      config.headers = global_headers
    end
  end

  after do
    Easyship.configure do |config|
      config.headers = {}
    end
  end
end
