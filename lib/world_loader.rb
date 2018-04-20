class WorldLoader

  def self.load_world
    begin
      world_name = "default_world"
      #world_name = "default_world_50npcs"
      world_name = "dev_work_items"
      world_json = JSON.parse(File.read("./world/#{world_name}.json"))
      Log.log 'world load ok'
      return world_json
    rescue
      raise 'Failed to load world'
    end
  end

end
