module Gameplay
  class MoveCharacter < GameplayCmd

    LIMIT_MOVE = 12

    def run

      cell_to = world.get_cell(params['to_x'], params['to_y'])
      cell_from = player.character.cell

      return false if cell_from.distance_to(cell_to) > LIMIT_MOVE

      if cell_from and cell_to and !cell_to.is_solid?
        pos_from = player.character.current_pos
        if pos_from.is_a? Array
          from_x = pos_from[0]
          from_y = pos_from[1]
        else
          from_x = pos_from.x
          from_y = pos_from.y
        end
        pathfinding = world.pathfinding.find_path(from_x, from_y, cell_to.x, cell_to.y)
        if pathfinding and pathfinding.size < 20
          player.character.set_pathfinding pathfinding
          player.character.cell = cell_to
          server.channel_push('all', ClientMessages.refresh_character(player.character))
        end
      end
    end

  end
end
