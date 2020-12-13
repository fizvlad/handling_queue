# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HandlingQueue do
  describe 'VERSION' do
    it { expect(described_class::VERSION).not_to be_nil }
  end

  describe '#handle' do
    let(:instance) { HandlingQueue.new(slice: slice, interval: interval, &block) }
    let(:slice) { 1 }
    let(:interval) { 0.1 }
    let(:block) do
      proc do |a|
        a.each { |e| e.re = e.obj * 2 }
      end
    end

    it :aggregate_failures do
      expect(instance.handle(1)).to eq(2)
      expect(instance.handle(5)).to eq(10)
      expect(instance.handle(10)).to eq(20)
    end

    context 'when shared between threads' do
      it :aggregate_failures do
        threads = []
        5.times do |i|
          threads << Thread.new do
            expect(instance.handle(i)).to eq(2 * i)
          end
          sleep 0.05
        end
        threads.each(&:join)
      end
    end

    context 'when slice is larger than 1' do
      let(:slice) { 2 }

      it :aggregate_failures do
        expect(instance.handle(1)).to eq(2)
        expect(instance.handle(5)).to eq(10)
        expect(instance.handle(10)).to eq(20)
      end
    end

    context 'when block returnes nil' do
      let(:block) do
        proc do |a|
          a.each { |e| e.re = nil }
        end
      end

      it :aggregate_failures do
        expect(instance.handle(1)).to eq(nil)
        expect(instance.handle(5)).to eq(nil)
        expect(instance.handle(10)).to eq(nil)
      end
    end
  end
end
