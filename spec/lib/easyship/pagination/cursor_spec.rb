# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Easyship::Pagination::Cursor do
  subject(:cursor) { described_class.new(client, path, params) }

  let(:client) { Easyship::Client.instance }
  let(:path) { '/2023-01/countries' }
  let(:params) { {} }

  describe '#all' do
    let(:results) { [] }

    context 'when no pages are available' do
      it 'yields one page' do
        VCR.use_cassette('countries/empty') do
          cursor.all { |p| results << p }

          expect(results.count).to eq(1)
        end
      end
    end

    context 'when multiple pages are available' do
      let(:expected_pages) { 3 } # 249 total items / 100 per page

      it 'yields each page of results' do
        VCR.use_cassette('countries') do
          cursor.all { |p| results << p }

          expect(results.count).to eq(expected_pages)
        end
      end
    end
  end
end
