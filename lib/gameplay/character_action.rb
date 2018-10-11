module Gameplay
  class CharacterAction < GameplayCmd
    def run
      return false unless player.character.is_delay_ok

      target_char = ObjectSpace._id2ref(params['char_id'])
      if target_char and target_char.is_a? Character
        pos1 = target_char.current_pos
        pos2 = @player.character.current_pos
        distance = @world.distance_of(pos1[0], pos1[1], pos2[0], pos2[1])

        # ATTACK 
        if distance.to_f <= 1.to_f and target_char.object_id != player.character.object_id
          total_damage = player.character.calc_atk + rand(5) -2
          total_damage = 1 if total_damage < 1

          target_char.hp -= total_damage
          if target_char.is_a? CharacterAI and target_char.follow_char.nil?
            target_char.follow_char = player.character
          end

          player.character.end_delay_at = Time.now.to_f + 0.5

          # kill
          if target_char.hp < 0
            target_char.cell = @world.get_cell(123, 125)
            target_char.hp = target_char.calc_max_hp
            target_char.follow_char = nil
            # add 1 attribute to killer
            player.character.attribute_balance += 1
          end

          if target_char.ws_id
            char_ws = ObjectSpace._id2ref(target_char.ws_id)
            world.server.send(ClientMessages.character_data(target_char.client_data), char_ws)
          end

          if player.character.ws_id
            world.server.send ClientMessages.character_data(player.character.client_data), ws
          end
          
          # DAMAGE ANIMATION
          damage_animation = {
            type: 'damage',
            value: total_damage
          }
          world.server.channel_push('all', ClientMessages.character_animation({
            character_id: target_char.object_id,
            animation: damage_animation 
          }))


          # ATTACK ANIMATION
          direction = 'top'
          direction = 'right'  if target_char.cell.x > player.character.cell.x
          direction = 'left'   if target_char.cell.x < player.character.cell.x
          direction = 'bottom' if target_char.cell.y > player.character.cell.y
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
          world.server.channel_push('all', ClientMessages.refresh_character(target_char))
        end
      end
    end
  end
end
