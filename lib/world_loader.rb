class WorldLoader

  def self.load_world
    begin
      world_json = JSON.parse(File.read('./world/default_world.json'))
      Log.log 'world load ok'
      return world_json
    rescue
      raise 'Failed to load world'
    end
  end

end