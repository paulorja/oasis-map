module Gameplay
  class MoveCharacter < GameplayCmd

    def run
      cell_to = world.get_cell(params['to_x'], params['to_y'])
      cell_from = player.character.cell
      if cell_from and cell_to and cell_to.terrain == 'grass'
        blocked_cells = Set.new

        # pathfinding
        for x in 0..(world.height - 1) do
          for y in 0..(world.width - 1) do
            if world.get_cell(x, y).terrain == 'water'
              blocked_cells.add([x, y])
            end
          end
        end

        map = PathfindingGenerator.new(blocked_cells, world.height, world.width)
        pathfinding = map.find_path(cell_from.x, cell_from.y, cell_to.x, cell_to.y)
        if pathfinding
          player.character.set_pathfinding pathfinding
          player.character.cell = cell_to
          server.channel_push('all', ClientMessages.move_character(player.character))
        end
      end
    end

  end
end
