class Player

  attr_accessor :character

  def initialize(nickname, body)
    @character = Character.new(nickname, body)
  end
  
  def play(gameplay_cmd)
    case gameplay_cmd.type
    when "move"
    when "chat"
    else
      return nil
    end
  end

  def is_valid?
    true if @character.valid_body
  end
  
end
