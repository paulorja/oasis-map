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
          total_damage = player.character.calc_atk + rand(5) -2
          total_damage = 1 if total_damage < 1

          char.hp -= total_damage
          
          # kill
          if char.hp < 0 
            char.cell = @world.get_cell(123, 125)
            char.hp = char.calc_max_hp
            # add 1 attribute to killer
            player.character.attribute_balance += 1
          end

          server.send(ClientMessages.character_data(char.client_data), char_ws)
          server.send ClientMessages.character_data(player.character.client_data), ws

          animation = {
            type: 'damage',
            value: total_damage
          }

          server.channel_push('all', ClientMessages.character_animation({nickname: char.nickname, animation: animation}))
          server.channel_push('all', ClientMessages.refresh_character(char))
        end
      end
    end
  end
end
