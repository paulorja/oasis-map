module Gameplay
  class RemoveEquip < GameplayCmd

    def run
      item = player.character.find_equip params['item_id']

      if player.character.remove_equip(item)
        player.character.inventory.add item
        server.send ClientMessages.inventory(player.character.inventory), ws
        server.channel_push('all', ClientMessages.refresh_character(player.character))
      end
    end

  end
end
