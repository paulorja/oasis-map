module GameEvents
  class SpawnUnit < GameEvent

    def initialize(spawn_index, world)
      @world = world
      @spawn_index = spawn_index
      @spawn_area = @world.unit_spawn_areas[@spawn_index]
      super(45)
    end

    def resolve(server)
      if can_resolve
        cell = @world.get_cell(@spawn_area[:x], @spawn_area[:y])
        if cell
          spawn = UNIT_SPAWNS[@spawn_area[:id]]
          attempts = 0

          finished = false
          while !finished do
            rand_x = rand(spawn['range']^2)
            rand_y = rand(spawn['range']^2)

            cell = @world.get_cell(@spawn_area[:x]-spawn['range'] + rand_x, @spawn_area[:y]-spawn['range'] + rand_y)
            if cell.unit_id.nil?
              cell.set_unit(spawn['unit_id'], @spawn_index)
              finished = true
            end

            attempts += 1
            if attempts > 9
              extend_resolve(60)
              return false
            end
          end

          if finished
            @world.refresh_pathfinding
            server.channel_push('all', ClientMessages.refresh_cell(cell))
          end
        end
        true
      end
    end

  end
end
