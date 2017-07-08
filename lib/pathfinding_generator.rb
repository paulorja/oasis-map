class PathfindingGenerator < Pathfinding

  def initialize(blocked_cells,  height, width)
    @blocked_cells = blocked_cells
    super(height, width, 1)
  end

  def blocked?(x,y)
    true if @blocked_cells.include? [x, y]
  end

end