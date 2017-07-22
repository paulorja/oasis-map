class WorldCreator

  def self.create
    @world_json = WorldLoader.load_world
    spawn_units = []

    @world = []
    @world_json['width'].times do
      @world << []
    end

    Log.log '[ World init started ]'
    @world_json['layers'].each do |layer|

      # TERRAIN
      if layer['name'] == 'terrain'
        Log.log '[ LOAD TERRAINS]'
        layer['data'].each_with_index do |cell, index|
          x = index % layer['width']
          y = index / layer['width']

          id_terrain = cell - @world_json['tilesets'][0]['firstgid']
          @world[x][y] = Cell.new(id_terrain, nil, x, y)
        end
      end

      #UNIT
      if layer['name'] == 'unit'
        Log.log '[ LOAD UNITS ]'
        layer['data'].each_with_index do |cell, index|
          x = index % layer['width']
          y = index / layer['width']

          if cell > 0
            id_unit = cell - @world_json['tilesets'][1]['firstgid']
            if UNITS[id_unit]
              @world[x][y].set_unit id_unit
            else
              raise "unit with id #{id_unit} not exist"
            end
          end
        end
      end

      # LOAD UNIT SPAWN
      if layer['name'] == 'spawn_unit'
        Log.log '[ LOAD UNIT SPAWNS ]'
        layer['data'].each_with_index do |cell, index|
          x = index % layer['width']
          y = index / layer['width']

          if cell > 0
            id_spawn_unit = cell - @world_json['tilesets'][2]['firstgid']
            if UNIT_SPAWNS[id_spawn_unit]
              spawn_units << { x: x, y: y, id: id_spawn_unit }
            else
              raise "spawn unit with id #{id_spawn_unit} not exist"
            end
          end
        end
      end
    end

    Log.log '[ World init finished ]'
    {world: @world , unit_spawn_areas: spawn_units }
  end

end