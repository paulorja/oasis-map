module Gameplay
  class UseItem < GameplayCmd

    def run
      item = player.character.inventory.find_item params['item_id']

      if item
        # equip
        if player.character.equip(item)
          player.character.inventory.remove item
          server.send ClientMessages.inventory(player.character.inventory), ws
          server.channel_push('all', ClientMessages.refresh_character(player.character))
        end

        # seed
        if item['private']['seed']
          stop_character
          if player.character.cell.unit_id.nil?
            player.character.cell.set_unit(item['private']['seed']['seed_unit_tsx_id'])
            player.character.inventory.remove_by_id item['public']['id']
            world.add_event GameEvents::EventSeed.new(item['private']['seed']['time'], player.character.cell, world)
            server.send ClientMessages.inventory(player.character.inventory), ws
            server.channel_push('all', ClientMessages.refresh_cell(player.character.cell))
          end
        end

        #build
        if item['private']['build']
          stop_character
          if player.character.cell.unit_id.nil?
            player.character.cell.set_unit(item['private']['build']['unit_tsx_id'])
            player.character.inventory.remove_by_id item['public']['id']
            world.refresh_pathfinding
            server.send ClientMessages.inventory(player.character.inventory), ws
            server.channel_push('all', ClientMessages.refresh_cell(player.character.cell))
          end
        end

      end
    end

    private

    def stop_character
      if player.character.is_moving
        Gameplay::MoveCharacter.new(type, { 'to_x' => player.character.current_pos[0], 'to_y' => player.character.current_pos[1]}, server, player, world, ws).run
      end
    end

  end
end
