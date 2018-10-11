module Gameplay
  class UseItem < GameplayCmd

    def run
      item = player.character.inventory.find_item params['item_id']

      if item
        # equip
        if player.character.equip(item)
          world.server.send ClientMessages.inventory(player.character.inventory), ws
          world.server.channel_push('all', ClientMessages.refresh_character(player.character))
        end

        # seed
        if item['private']['seed']
          stop_character
          if player.character.cell.unit_id.nil?
            player.character.cell.set_unit(item['private']['seed']['seed_unit_tsx_id'])
            player.character.inventory.remove_by_id item['public']['id']
            world.add_event GameEvents::EventSeed.new(item['private']['seed']['time'], player.character.cell, world)
            world.server.send ClientMessages.inventory(player.character.inventory), ws
            world.server.channel_push('all', ClientMessages.refresh_cell(player.character.cell))
          end
        end

        #build
        if item['private']['build']
          stop_character
          if player.character.cell.unit_id.nil?
            player.character.cell.set_unit(item['private']['build']['unit_tsx_id'])
            player.character.inventory.remove_by_id item['public']['id']
            world.refresh_pathfinding
            world.server.send ClientMessages.inventory(player.character.inventory), ws
            world.server.channel_push('all', ClientMessages.refresh_cell(player.character.cell))
          end
        end

        #consume effect
        if item['private']['consume_effect']
          #effect
          if item['private']['consume_effect']['heal']
            player.character.increment_hp(item['private']['consume_effect']['heal'])
          end

          #remove item
          player.character.inventory.remove_by_id item['public']['id']

          #server
          world.server.send ClientMessages.inventory(player.character.inventory), ws
          world.server.send ClientMessages.character_data(player.character.client_data), ws
        end

        #character animation
        if item['private']['character_animation']
          world.server.send ClientMessages.character_animation({nickname: player.character.nickname, animation: item['private']['character_animation']}), ws
        end 
      end
    end

    private

    def stop_character
      if player.character.is_moving
        Gameplay::MoveCharacter.new(type, { 'x' => player.character.current_pos[0], 'y' => player.character.current_pos[1]}, player, world, ws).run
      end
    end

  end
end
