class WorldLoader

  def self.load_world
    begin
      world_json = JSON.parse(File.read('./world/default_world.json'))
      Log.log 'world load ok'
      return world_json
    rescue
      Log.alert 'Failed to load world'
      exit
    end
  end

end