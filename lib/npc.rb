class Npc 

  attr_accessor :start_x, :start_y, :character
  
  def initialize(nickname, body_style)
    @character = Character.new(nickname, body_style)
    @start_x = 0
    @start_y = 0
  end

end
