module GameEvents
  class EventSeed < GameEvent

    def initialize(time_to_resolve, cell, world)
      @cell = cell
      @world = world
      super(time_to_resolve)
    end

    def resolve(server)
      if can_resolve
        @cell.unit = @world.units[@cell.unit['private']['seed']['next_unit_tsx_id'].sample]
        server.channel_push('all', ClientMessages.refresh_cell(@cell))
        true
      end
    end

  end
end
