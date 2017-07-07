class Cell
  
  attr_accessor :character, :terrain, :unit

  def initialize(terrain, x, y)
    @character = nil
    @terrain = terrain
    @unit = nil
    @x = x
    @y = y
  end

  def client_data 
  	{
  		terrain: @terrain,
  		unit: @unit,
  		character: (@character == nil ? nil : @character.client_data),
      x: @x,
      y: @y
  	}
  end

end
