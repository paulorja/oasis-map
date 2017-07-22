class GameObjectLoader

  def self.load_terrains
    tsx_loader 'terrain'
  end

  def self.load_units
    tsx_loader 'unit'
  end

  def self.load_craft(level)
    JSON.parse(File.read("./game_objects/crafting/crafting_level_#{level}.json"))
  end

  def self.load_unit_spawns
    unit_spawns = {}
    Dir.glob("./game_objects/spawn_unit/*.json") do |spawn_file|
      spawn_json = JSON.parse(File.read(spawn_file))
      if unit_spawns[spawn_json['id']].nil?
        unit_spawns[spawn_json['id']] = spawn_json
      else
        raise "ID ALREADY USED file => #{spawn_file} json =: #{spawn_json.inspect}"
      end
    end
    unit_spawns
  end

  def self.load_items
    items = {}
    Dir.glob("./game_objects/item/*.json") do |item_file|
      item_json = JSON.parse(File.read(item_file))
      if items[item_json['public']['id']].nil?
        items[item_json['public']['id']] = item_json
      else
        raise "ID ALREADY USED file => #{item_file} json =: #{item_json.inspect}"
      end
    end
    items
  end

  def self.tsx_loader(dir)
    objects = {}
    Dir.glob("./game_objects/#{dir}/*.json") do |objects_file|
      objects_json = JSON.parse(File.read(objects_file))
      if objects_json['id'].nil?
        raise "Can not found id from file => #{objects_file} json =: #{objects_json.inspect}"
      end
      if objects[objects_json['id']].nil?
        objects[objects_json['id']] = objects_json
      else
        raise "ID ALREADY USED file => #{objects_file} json =: #{objects_json.inspect}"
      end
    end
    Log.log("#{dir} loader ok")
    objects
  end

end