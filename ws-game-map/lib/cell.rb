class Cell
  
  attr_reader :unit_id, :terrain_id, :drops, :x, :y, :spawn_index

  def initialize(terrain_id, unit_id, x, y)
    @terrain_id = terrain_id
    @unit_id = unit_id
    @spawn_index = nil
    @drops = []
    @x = x
    @y = y
  end

  def client_data 
  	data = {
  		t: @terrain_id,
      x: @x,
      y: @y
  	}
    data[:u] = @unit_id unless @unit_id.nil?
    data[:drops] = @drops unless @drops.nil?
    data
  end

  def add_drop(item)
    @drops.push({item: item, x: rand(32), y: rand(32)})
  end

  def t_data
    TERRAINS[@terrain_id]
  end

  def u_data
    UNITS[@unit_id]
  end

  def set_unit(id, spawn_index = nil)
    if id.nil?
      @unit_id = nil
      @spawn_index = nil
    elsif UNITS[id]
      @unit_id = id
      if spawn_index
        @spawn_index = spawn_index
      end
    else
      raise 'UNIT NOT EXIST'
    end
  end

  def is_solid?
    return false if u_data and u_data['bridge'] and u_data['bridge'] == true
    if t_data['solid'] or (u_data and u_data['solid'])
      true
    else
      false
    end
  end

  def distance_to(cell_to)
    Math.sqrt(((cell_to.x-x)**2) + ((cell_to.y-y)**2))
  end

  def get_unit_drops
    drops = []
    if u_data and u_data['drops']
      u_data['drops'].each do |drop|
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
