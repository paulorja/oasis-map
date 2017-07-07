class Cell
  
  attr_accessor :terrain, :unit, :x, :y

  def initialize(terrain, x, y)
    @terrain = terrain
    @unit = nil
    @x = x
    @y = y
  end

  def client_data 
  	{
  		terrain: @terrain,
  		unit: @unit,
      x: @x,
      y: @y
  	}
  end

end
