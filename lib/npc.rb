class Npc 

  attr_accessor :start_x, :start_y, :character
  
  def initialize(nickname, body_style)
    @character = CharacterAI.new(nickname, body_style, self)
    @start_x = 0
    @start_y = 0
  end

end
