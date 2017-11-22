module Gameplay
  class CharacterAction < GameplayCmd

    def run
      char = ObjectSpace._id2ref(params['char_id'])
      if char and char.is_a? Character
        char_ws = ObjectSpace._id2ref(char.ws_id)
        pos1 = char.current_pos
        pos2 = @player.character.current_pos
        distance = @world.distance_of(pos1[0], pos1[1], pos2[0], pos2[1])

        if distance.to_f < 2.to_f and char.nickname != player.character.nickname
          # attack
          total_damage = char.get_atk + rand(5) -2

          char.hp -= total_damage
          puts char.character_data
          server.send(ClientMessages.character_data(char.character_data), char_ws)
          
          animation = {
            type: 'damage',
            value: total_damage
          }

          server.channel_push('all', ClientMessages.character_animation({nickname: char.nickname, animation: animation}))
        end
      end

    end

  end
end
