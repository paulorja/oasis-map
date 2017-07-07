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
        row << Cell.new(@world_file_hash[x][y]["terrain"], x, y)
      end
      @world << row
    end
  end

  def add_character(character)
    char_cell = start_character_cell
    char_cell.character = character
    char_cell.character.cell = char_cell
  end

  def start_character_cell
    for y in 0..(@height - 1) do
      for x in 0..(@width - 1) do
        return @world[x][y] if @world[x][y].terrain == 'grass' and @world[x][y].character == nil
      end
    end
  end

  def move_character(character, x, y)

  end

  def gameplay(json_msg, player) 
    case json_msg["gameplay_name"]
    when "move"
      puts "move"
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

end
