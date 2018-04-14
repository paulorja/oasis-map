class World

  attr_accessor :server
  attr_reader :width, :height, :items, :terrains, :units, :pathfinding, :events, :unit_spawn_areas, :npcs

  def initialize(server)
    @server = server
    world_created = WorldCreator.create
    @world = world_created[:world]
    @unit_spawn_areas = world_created[:unit_spawn_areas]
    @npcs = world_created[:npcs]
    start_units
    @height = @world.size
    @width = @world[0].size
    @items = GameObjectLoader.load_items
    @terrains = GameObjectLoader.load_terrains
    @units = GameObjectLoader.load_units
    @pathfinding = PathfindingGenerator.new(@world, @height, @width)
    @events = []
  end

  def add_character(character, char_cell = nil)
    if char_cell.nil?
      char_cell = get_cell(125+rand(2), 125+rand(2))
    end
    character.cell = char_cell
    character.world = self
  end

  def gameplay(json_msg, player, server, ws)
    gameplay_classname = json_msg['gameplay_name'].split("_").map(&:capitalize).join()
    gameplay_classname = "Gameplay::#{gameplay_classname}"
    @gameplay = eval(gameplay_classname)
    @gameplay.new(json_msg, player, self, ws).run
  end

  def resolve_events(server)
    @events.each do |event|
      @events.delete event if event.resolve server
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

  def add_event(event)
    if event.is_a? GameEvents::GameEvent
      @events << event
    end
  end

  def start_units
    unit_spawn_areas.each_with_index do |area, index|
      spawn = UNIT_SPAWNS[area[:id]]
      spawn['amount'].times do
        finished = false
        while !finished do
          rand_x = rand(spawn['range']^2)
          rand_y = rand(spawn['range']^2)

          cell = @world[area[:x]-spawn['range'] + rand_x][area[:y]-spawn['range'] + rand_y]
          if cell.unit_id.nil?
            cell.set_unit(spawn['unit_id'], index)
            finished = true
          end
        end
      end
    end
  end

  def distance_of(x1, y1, x2, y2)
    distance = Math.sqrt(((x2-x1)**2) + ((y2-y1)**2))
    '%.1f' % distance
  end
  
end
