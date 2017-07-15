class World

  attr_reader :width, :height, :items, :terrains, :units, :pathfinding

  def initialize
    @world = WorldCreator.create
    @height = @world.size
    @width = @world[0].size
    @items = GameObjectLoader.load_items
    @terrains = GameObjectLoader.load_terrains
    @units = GameObjectLoader.load_units
    @pathfinding = PathfindingGenerator.new(@world, @height, @width)
  end

  def add_character(character)
    char_cell = get_cell(63, 65)
    character.cell = char_cell
  end

  def gameplay(json_msg, player, server, ws)
    case json_msg['gameplay_name']
    when 'move'
      Gameplay::MoveCharacter.new(json_msg['gameplay_name'], json_msg['params'], server, player, self, ws).run
    when 'cell_action'
      Gameplay::CellAction.new(json_msg['gameplay_name'], json_msg['params'], server, player, self, ws).run
    when 'take_cell_drops'
      Gameplay::TakeCellDrops.new(json_msg['gameplay_name'], json_msg['params'], server, player, self, ws).run
    when 'global_chat'
      Gameplay::GlobalChat.new(json_msg['gameplay_name'], json_msg['params'], server, player, self, ws).run
    when 'use_item'
      Gameplay::UseItem.new(json_msg['gameplay_name'], json_msg['params'], server, player, self, ws).run
    when 'remove_equip'
      Gameplay::RemoveEquip.new(json_msg['gameplay_name'], json_msg['params'], server, player, self, ws).run
    else
      raise 'fuck'
    end
  end

  def part_of_world(x, y, range)
    range+= 500
    client_world_part = []
    rx = x
    range.times do
      ry = y
      range.times do
        if @world[rx] and @world[rx][ry]
          client_world_part << @world[rx][ry].client_data
        else
          break
        end
        ry += 1
      end
      rx += 1;
    end
    client_world_part
  end

  def full_world_to_client
    get_world.map{|row| row.map{|cell| cell.client_data}}
  end

  def refresh_pathfinding
    @pathfinding = PathfindingGenerator.new(@world, @height, @width)
  end

  def get_cell(x, y)
    return @world[x][y] if x and y and @world[x] and @world[x][y] and @world[x][y].is_a? Cell
    nil
  end

end
