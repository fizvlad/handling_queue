# frozen_string_literal: true

require_relative 'handling_queue/version'
require_relative 'handling_queue/request'

# Execute handling process from time to time.
class HandlingQueue
  # @param slice [Integer] amount of handled objects in single +handler+ call.
  # @param interval [Integer] interval between handler calls in seconds.
  # @yieldparam obj [Array<Request>] array of handling requests.
  def initialize(slice: 1, interval: 1, &handler)
    @slice = slice
    @interval = interval
    @handler = handler

    @requests_queue = [] # Use Array with #push and #shift methods to have queue.
    # NOTE: effeciency is pretty good, btw. O(1) if no new memory required.

    @mutex = Mutex.new # Queue and requests accessing mutex
    @cv = ConditionVariable.new # Condition variable to signal when some of results are ready.

    @working = false
    @thread = nil
    start_handler_thread
  end

  # Request handling of +obj+ and wait for it to be handled.
  # @param obj [void] object to be handled.
  # @return [void] result of handling.
  def handle(obj)
    request = Request.new(obj)
    @mutex.synchronize do
      @requests_queue.push(request)
      @cv.wait(@mutex) until request.re?
      request.re
    end
  end

  private

  def start_handler_thread
    @working = true
    @thread = Thread.new do
      handler_iteration while @working
    end
    @thread.name = 'handling_queue'
  end

  def handler_iteration
    sleep @interval
    @mutex.synchronize do
      arg = @requests_queue.shift(@slice)
      @handler.call(arg) unless arg.empty?
      @cv.broadcast
    end
  end

  def stop_handler_thread
    @working = false
    @thread.join
    @thread = nil
  end
end
