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

  def self.load_items
    items = {}
    Dir.glob("./game_objects/item/*.json") do |item_file|
      item_json = JSON.parse(File.read(item_file))
      if items[item_json['public']['id']].nil?
        items[item_json['public']['id']] = item_json
      else
        Log.alert "ID ALREADY USED file => #{item_file} json =: #{item_json.inspect}"
        exit
      end
    end
    items
  end

  def self.tsx_loader(dir)
    objects = {}
    Dir.glob("./game_objects/#{dir}/*.json") do |objects_file|
      objects_json = JSON.parse(File.read(objects_file))
      if objects_json['private'].nil? or objects_json['private']['tsx_id'].nil?
        Log.alert "Can not found tsx id from file => #{objects_file} json =: #{objects_json.inspect}"
        exit
      end
      if objects[objects_json['private']['tsx_id']].nil?
        objects[objects_json['private']['tsx_id']] = objects_json
      else
        Log.alert "TSX ID ALREADY USED file => #{objects_file} json =: #{objects_json.inspect}"
        exit
      end
    end
    Log.log("#{dir} loader ok")
    objects
  end

end