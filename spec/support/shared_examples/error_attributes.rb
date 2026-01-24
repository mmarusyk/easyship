# frozen_string_literal: true

RSpec.shared_examples 'an error with standard attributes' do
  it 'includes standard error attributes' do
    expect(error).to respond_to(:message)
      .and respond_to(:body_error)
      .and respond_to(:response_body)
      .and respond_to(:response_headers)
  end
end
