module Gameplay
  class MoveCharacter < GameplayCmd

    LIMIT_MOVE = 12

    def run

      cell_to = world.get_cell(params['to_x'], params['to_y'])
      cell_from = player.character.cell

      #if char is locked
      if cell_from.is_solid?
        top = world.get_cell(cell_from.x, cell_from.y-1)
        left = world.get_cell(cell_from.x-1, cell_from.y)
        bottom = world.get_cell(cell_from.x, cell_from.y+1)
        right = world.get_cell(cell_from.x+1, cell_from.y)

        if !top.is_solid? and cell_to.y < cell_from.y
          player.character.cell = top
        elsif !bottom.is_solid? and cell_to.y > cell_from.y
          player.character.cell = bottom
        elsif !left.is_solid? and cell_to.x < cell_from.x
          player.character.cell = left
        elsif !right.is_solid?  and cell_to.x > cell_from.x
          player.character.cell = right
        end
      end

      return false if cell_from.distance_to(cell_to) > LIMIT_MOVE
      return false unless player.character.is_cooldown_ok

      if cell_from and cell_to and !cell_to.is_solid?
        pos_from = player.character.current_pos
        from_x = pos_from[0]
        from_y = pos_from[1]

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
