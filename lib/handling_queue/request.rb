# frozen_string_literal: true

class HandlingQueue
  # Represents single request to {HandlingQueue}.
  class Request
    # @return [void] object to be handled.
    attr_accessor :obj

    # @return [void] handled object or +nil+ if not handled yet.
    attr_accessor :re

    # @param obj [void] object to be handled.
    def initialize(obj)
      @obj = obj
      @re = nil
    end
  end
end
