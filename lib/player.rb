class Player

  attr_accessor :character

  def initialize(nickname, body_style)
    @character = Character.new(nickname, body_style)
  end
  
  def is_valid?
    true if @character.valid_body_style
  end
  
end
