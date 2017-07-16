module Gameplay
  class RequestCraft < GameplayCmd

    def run
      server.send ClientMessages.refresh_craft_list(player.character.craft_list), ws
    end

  end
end
