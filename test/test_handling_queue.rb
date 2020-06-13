# frozen_string_literal: true

require_relative 'helper'

class HandlingQueueTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::HandlingQueue::VERSION
  end

  def test_correct_work_with_single_thread
    handling_queue = HandlingQueue.new(slice: 1, interval: 0.1) do |a|
      a.each { |e| e.re = e.obj * 2 }
    end

    assert handling_queue.handle(1) == 2, 'Bad handled value'
    assert handling_queue.handle(5) == 10, 'Bad handled value'
    assert handling_queue.handle(10) == 20, 'Bad handled value'
  end

  def test_correct_work_with_multiple_threads
    handling_queue = HandlingQueue.new(slice: 1, interval: 0.1) do |a|
      a.each { |e| e.re = e.obj * 2 }
    end

    threads = []
    5.times do |i|
      threads << Thread.new do
        assert handling_queue.handle(i) == i * 2, 'Bad handled value'
      end
      sleep 0.05
    end
    threads.each(&:join)
  end

  def test_correct_work_with_slices
    handling_queue = HandlingQueue.new(slice: 2, interval: 1) do |a|
      a.each { |e| e.re = e.obj * 2 }
    end

    threads = []
    5.times do |i|
      threads << Thread.new do
        assert handling_queue.handle(i) == i * 2, 'Bad handled value'
      end
      sleep 0.05
    end
    threads.each(&:join)
  end
end
