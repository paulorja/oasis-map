module Gameplay
  class Craft < GameplayCmd

    def run
      craft_item = nil;
      player.character.craft_list.each do |item|
        craft_item = item if item['id'] == params['item_id']
      end

      if craft_item
        if player.character.craft(craft_item, world.items)
          player.character.add_craft_exp craft_item['exp']
          world.server.send ClientMessages.craft_info(player.character.craft_info), ws
          world.server.send ClientMessages.refresh_craft_list(player.character.craft_list), ws
          world.server.send ClientMessages.inventory(player.character.inventory), ws
        end
      end
    end

  end
end
