module Gameplay
  class UseItem < GameplayCmd

    def run
      item = player.character.inventory.find_item params['item_id']

      if item
        # equip
        if player.character.equip(item)
          player.character.inventory.remove item
          server.send ClientMessages.inventory(player.character.inventory), ws
          server.channel_push('all', ClientMessages.refresh_character(player.character))
        end

        # seed
        if item['private']['seed']
          if player.character.cell.unit.nil?
            player.character.cell.unit = world.units[5]
            server.send ClientMessages.inventory(player.character.inventory), ws
            server.channel_push('all', ClientMessages.refresh_cell(player.character.cell))
          end
        end
      end
    end

  end
end
