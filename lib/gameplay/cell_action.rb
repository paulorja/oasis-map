module Gameplay
  class CellAction < GameplayCmd

    def run
      cell = world.get_cell(params['x'], params['y'])
      char = player.character
      if cell and char.is_action_collision?(cell.x, cell.y)
        if char.is_delay_ok
          if cell.unit_id and char.right_hand and char.right_hand['public']['can_collect'].include? cell.unit_id
            cell.get_unit_drops.each { |item_id| cell.add_drop(world.items[item_id])}
            if cell.spawn_index
              world.add_event GameEvents::SpawnUnit.new cell.spawn_index, world
            end
            cell.set_unit(nil)
            world.refresh_pathfinding
            player.character.end_delay_at = Time.now.to_f + 0.5

            # ATTACK ANIMATION
            direction = 'top'
            direction = 'right'  if cell.x > char.cell.x
            direction = 'left'   if cell.x < char.cell.x
            direction = 'bottom' if cell.y > char.cell.y
            attack_animation = {
              type: 'attack',
              duration: 0.5,
              direction: direction
            }
            server.channel_push('all', ClientMessages.character_animation({
              character_id: char.object_id,
              animation: attack_animation
            }))
            #

            server.channel_push('all', ClientMessages.refresh_cell(cell))
            server.send ClientMessages.inventory(player.character.inventory), ws
          end
        end
      end
    end

  end
end
