module Gameplay
  class MoveCharacter < GameplayCmd

    def run
      cell_to = world.get_cell(params['to_x'], params['to_y'])
      cell_from = player.character.cell
      if cell_from and cell_to and cell_to.terrain == 'grass'
        player.character.cell = cell_to
        # push
        server.channel_push('all', ClientMessages.move_character(player.character))
      end
    end

  end
end
