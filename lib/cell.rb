class Cell
  
  attr_accessor :terrain, :unit, :drops, :x, :y

  def initialize(terrain, unit, x, y)
    @terrain = terrain
    @unit = unit
    @drops = []
    @x = x
    @y = y
  end

  def client_data 
  	{
  		terrain: @terrain['public'],
  		unit: @unit != nil ? @unit['public'] : nil,
      drops: @drops,
      x: @x,
      y: @y
  	}
  end

  def add_drop(item)
    @drops.push({item: item, x: rand(32), y: rand(32)})
  end

  def is_solid?
    terrain['public']['solid'] or (unit and unit['public']['solid'])
  end

  def distance_to(cell_to)
    Math.sqrt(((cell_to.x-x)**2) + ((cell_to.y-y)**2))
  end

  def get_unit_drops
    drops = []
    if unit
      unit['public']['drops'].each do |drop|
        drops << drop['item'] if rand(100) <= drop['percent']
      end
    end
    drops
  end

  def send_drops_to_char(char)
    @drops.each do |drop|
      char.inventory.add drop[:item]
    end
    @drops = []
  end

end
