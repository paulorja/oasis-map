module Gameplay
  class CharacterData < GameplayCmd

    def run
      puts 'TA LOKO TIO'
      server.send ClientMessages.character_data(player.character.client_data), ws
    end

  end
end
