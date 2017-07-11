module Gameplay
  class UseItem < GameplayCmd

    def run
      item = player.character.inventory.find_item params['item_id']

      if item
        if player.character.equip(item)
          player.character.inventory.remove item
          server.send ClientMessages.inventory(player.character.inventory), ws
          server.channel_push('all', ClientMessages.refresh_character(player.character))
        end
      end
    end

  end
end
