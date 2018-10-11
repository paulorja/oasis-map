class Player

  attr_accessor :character

  def initialize(nickname, body_style, ws_id)
    @character = Character.new(nickname, body_style, ws_id)
  end
  
  def is_valid?
    true if @character.valid_body_style
  end
  
end
