module Authmac
  class TimestampChecker
    def initialize(max_behind, max_ahead)
      @max_behind = max_behind
      @max_ahead  = max_ahead
    end

    def validate(timestamp)
      not_too_old(timestamp) and not_too_new(timestamp)
    end

    private

    def not_too_old(timestamp)
      (Time.now - @max_behind) <= Time.at(timestamp)
    end

    def not_too_new(timestamp)
      Time.at(timestamp) <= (Time.now + @max_ahead)
    end
  end
end
