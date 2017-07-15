module GameEvents
  class EventSeed < GameEvent

    def initialize(time_to_resolve, cell, world)
      @cell = cell
      @world = world
      super(time_to_resolve)
    end

    def resolve(server)
      if can_resolve
        if @cell.unit['private'] and @cell.unit['private']['seed'] and @cell.unit['private']['seed']['next_unit_tsx_id']
          @cell.unit = @world.units[@cell.unit['private']['seed']['next_unit_tsx_id'].sample]
          @world.refresh_pathfinding
          server.channel_push('all', ClientMessages.refresh_cell(@cell))
        end

        true
      end
    end

  end
end
