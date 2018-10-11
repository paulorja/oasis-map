module GameEvents

  class GameEvent

    def initialize(time_to_resolve)
      @time_to_resolve = Time.now.to_f + time_to_resolve
    end

    def can_resolve
      Time.now.to_f > @time_to_resolve
    end

    def extend_resolve(time)
      @time_to_resolve = Time.now.to_f + time
    end


  end
end
