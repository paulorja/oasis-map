module Gameplay
  class CharacterData < GameplayCmd

    def run
      server.send ClientMessages.character_data(player.character.character_data), ws
    end

  end
end
