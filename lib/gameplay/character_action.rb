module Gameplay
  class CharacterAction < GameplayCmd
    def run
      return false unless player.character.is_delay_ok

      char = ObjectSpace._id2ref(params['char_id'])
      if char and char.is_a? Character
        pos1 = char.current_pos
        pos2 = @player.character.current_pos
        distance = @world.distance_of(pos1[0], pos1[1], pos2[0], pos2[1])

        # ATTACK 
        if distance.to_f <= 1.to_f and char.object_id != player.character.object_id
          total_damage = player.character.calc_atk + rand(5) -2
          total_damage = 1 if total_damage < 1

          char.hp -= total_damage
          
          player.character.end_delay_at = Time.now.to_f + 0.5

          # kill
          if char.hp < 0 
            char.cell = @world.get_cell(123, 125)
            char.hp = char.calc_max_hp
            # add 1 attribute to killer
            player.character.attribute_balance += 1
          end

          if char.ws_id
            char_ws = ObjectSpace._id2ref(char.ws_id)
            world.server.send(ClientMessages.character_data(char.client_data), char_ws)
          end
          world.server.send ClientMessages.character_data(player.character.client_data), ws
          
          # DAMAGE ANIMATION
          damage_animation = {
            type: 'damage',
            value: total_damage
          }
          world.server.channel_push('all', ClientMessages.character_animation({
            character_id: char.object_id,
            animation: damage_animation 
          }))


          # ATTACK ANIMATION
          direction = 'top'
          direction = 'right'  if char.cell.x > player.character.cell.x
          direction = 'left'   if char.cell.x < player.character.cell.x
          direction = 'bottom' if char.cell.y > player.character.cell.y
          attack_animation = {
            type: 'attack',
            duration: 0.5,
            direction: direction
          }
          world.server.channel_push('all', ClientMessages.character_animation({
            character_id: player.character.object_id,
            animation: attack_animation
          }))

          #
          world.server.channel_push('all', ClientMessages.refresh_character(char))
        end
      end
    end
  end
end
