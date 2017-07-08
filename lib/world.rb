class World

  attr_reader :width, :height

  def initialize
    @world = []
    @world_file_hash = JSON.parse(File.read('./world/world.json'))
    @height =  @world_file_hash.size
    @width = @world_file_hash[0].size
    init_world
  end

  def init_world
    for x in 0..(@height - 1) do
      row = []
      for y in 0..(@width - 1) do
        row << Cell.new(
            @world_file_hash[x][y]['terrain'],
            @world_file_hash[x][y]['unit'],
            x,
            y)
      end
      @world << row
    end
  end

  def add_character(character)
    char_cell = get_cell(0, 0)
    character.cell = char_cell
  end

  def gameplay(json_msg, player, server)
    case json_msg['gameplay_name']
    when 'move'
      Gameplay::MoveCharacter.new(json_msg['gameplay_name'], json_msg['params'], server, player, self).run
    when 'global_chat'
      Gameplay::GlobalChat.new(json_msg['gameplay_name'], json_msg['params'], server, player, self).run
    else
      raise 'fuck'
    end
  end

  def part_of_world(x, y, range)
    client_world_part = []
    rx = x
    ry = y
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

  def get_cell(x, y)
    return @world[x][y] if x and y and @world[x] and @world[x][y] and @world[x][y].is_a? Cell
    nil
  end

end
