module Gameplay
  class IncrementCharAttr < GameplayCmd

    def run
      if player.character.increment_attr(params['attr'])
        server.send ClientMessages.character_data(player.character.client_data), ws
      end
    end

  end
end
