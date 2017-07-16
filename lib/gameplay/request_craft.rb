module Gameplay
  class RequestCraft < GameplayCmd

    def run
      player.character.refresh_craft_list
      server.send ClientMessages.refresh_craft_list(player.character.craft_list), ws
    end

  end
end
