class PathfindingGenerator < Pathfinding

  def initialize(world, height, width)
    @world = world
    super(height, width, 1)
  end

  def blocked?(x,y)
    @world[x][y].is_solid?
  end

end