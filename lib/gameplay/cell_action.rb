module Gameplay
  class CellAction < GameplayCmd

    def run
      cell = world.get_cell(params['x'], params['y'])
      char = player.character
      if cell and char.is_action_collision?(cell.x, cell.y)
        if char.is_cooldown_ok
          if cell.unit_id and char.right_hand and char.right_hand['public']['can_collect'].include? cell.unit_id
            cell.get_unit_drops.each { |item_id| cell.add_drop(world.items[item_id])}
            if cell.spawn_index
              world.add_event GameEvents::SpawnUnit.new cell.spawn_index, world
            end
            cell.set_unit(nil)
            world.refresh_pathfinding
            player.character.cooldown = Time.now.to_f + 0.5
            server.channel_push('all', ClientMessages.refresh_cell(cell))
            server.send ClientMessages.inventory(player.character.inventory), ws
          end
        end
      end
    end

  end
end
