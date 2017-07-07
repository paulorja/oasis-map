module Gameplay
  class MoveCharacter < GameplayCmd

    def run
      cell_to = world.get_cell(params['to_x'], params['to_y'])
      cell_from = player.character.cell
      if cell_from and cell_to and cell_to.terrain == 'grass' and cell_to.character.nil?
        cell_from.character = nil
        cell_to.character = player.character
        player.character.cell = cell_to
        # push
        server.channel_push('all', ClientMessages.refresh_cell(cell_from))
        server.channel_push('all', ClientMessages.refresh_cell(cell_to))
      end
    end

  end
end
