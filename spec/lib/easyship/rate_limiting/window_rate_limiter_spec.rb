# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Easyship::RateLimiting::WindowRateLimiter do
  describe '#throttle!' do
    context 'when under all limits' do
      it 'does not sleep' do
        limiter = described_class.new(requests_per_second: 10, requests_per_minute: 60)
        base = Time.at(0)
        allow(Time).to receive(:now).and_return(base, base + 0.05, base + 0.10)
        allow(limiter).to receive(:sleep)

        3.times { limiter.throttle! }

        expect(limiter).not_to have_received(:sleep)
      end
    end

    context 'when exceeding the per-second limit' do
      it 'sleeps until the next second window' do
        limiter = described_class.new(requests_per_second: 2, requests_per_minute: nil)
        t0 = Time.at(0.0)
        t1 = Time.at(0.4)
        t2 = Time.at(0.8)

        allow(Time).to receive(:now).and_return(t0, t1, t2)
        allow(limiter).to receive(:sleep)

        3.times { limiter.throttle! }

        expect(limiter).to have_received(:sleep).at_least(:once).with(satisfy { |x| x.is_a?(Numeric) && x > 0 })
      end
    end

    context 'when exceeding the per-minute limit' do
      it 'sleeps until the next minute window' do
        limiter = described_class.new(requests_per_second: nil, requests_per_minute: 2)
        t0 = Time.at(0)
        t1 = Time.at(10)
        t2 = Time.at(20)

        allow(Time).to receive(:now).and_return(t0, t1, t2)
        allow(limiter).to receive(:sleep)

        3.times { limiter.throttle! }

        expect(limiter).to have_received(:sleep).at_least(:once).with(satisfy { |x| x.is_a?(Numeric) && x > 0 })
      end
    end
  end
end
