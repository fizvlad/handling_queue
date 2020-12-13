# frozen_string_literal: true

class HandlingQueue
  # Represents single request to {HandlingQueue}.
  class Request
    # @return [void] object to be handled.
    attr_accessor :obj

    # @return [void] handled object or +nil+ if not handled yet.
    def re
      return @re if re?
    end

    attr_writer :re

    # @return [Boolean] whether handled
    def re?
      defined? @re
    end

    # @param obj [void] object to be handled.
    def initialize(obj)
      @obj = obj
    end
  end
end
