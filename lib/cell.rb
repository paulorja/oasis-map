class Cell
  
  attr_accessor :terrain, :unit, :x, :y

  def initialize(terrain, unit, x, y)
    @terrain = terrain
    @unit = unit
    @x = x
    @y = y
  end

  def client_data 
  	{
  		terrain: @terrain['public'],
  		unit: @unit != nil ? @unit['public'] : nil,
      x: @x,
      y: @y
  	}
  end

  def is_solid?
    terrain['public']['solid'] or (unit and unit['public']['solid'])
  end

  def distance_to(cell_to)
    Math.sqrt(((cell_to.x-x)**2) + ((cell_to.y-y)**2))
  end

end
