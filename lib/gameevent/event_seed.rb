module GameEvents
  class EventSeed < GameEvent

    def initialize(time_to_resolve, cell, world)
      @cell = cell
      @world = world
      super(time_to_resolve)
    end

    def resolve(server)
      if can_resolve
        if @cell.u_data and @cell.u_data['seed'] and @cell.u_data['seed']['next_unit_tsx_id']
          @cell.set_unit(@cell.u_data['seed']['next_unit_tsx_id'].sample)
          @world.refresh_pathfinding
          server.channel_push('all', ClientMessages.refresh_cell(@cell))
        end
        true
      end
    end

  end
end
