class WorldCreator

  def self.create
    @terrains = GameObjectLoader.load_terrains
    @units = GameObjectLoader.load_units
    @world_json = WorldLoader.load_world

    @world = []
    @world_json['width'].times do
      @world << []
    end

    Log.log '[ World creation started ]'
    @world_json['layers'].each do |layer|

      # TERRAIN
      if layer['name'] == 'terrain'
        layer['data'].each_with_index do |cell, index|
          x = index % layer['width']
          y = index / layer['width']

          id_terrain = cell - @world_json['tilesets'][0]['firstgid']
          @world[x][y] = Cell.new(@terrains[id_terrain], nil, x, y)
        end
      end

      #UNIT
      if layer['name'] == 'unit'
        layer['data'].each_with_index do |cell, index|
          x = index % layer['width']
          y = index / layer['width']

          id_unit = cell - @world_json['tilesets'][1]['firstgid']
          if @units[id_unit]
            @world[x][y].unit = @units[id_unit]
          end
        end
      end
    end

    Log.log '[ World creation finished ]'
    @world
  end

end