module Gameplay
  class TakeCellDrops < GameplayCmd

    def run
      char = player.character
      unless char.is_moving
        refresh_cell_and_inventory = false
        if char.cell.drops.size > 0
          refresh_cell_and_inventory = true
        end
        char.cell.send_drops_to_char(char)

        if refresh_cell_and_inventory
          server.channel_push('all', ClientMessages.refresh_cell(char.cell))
          server.send ClientMessages.inventory(player.character.inventory), ws
        end
      end
    end

  end
end
