class Player

  attr_accessor :character

  def initialize(nickname)
    @character = Character.new(nickname)
  end
  
  def play(gameplay_cmd)
    case gameplay_cmd.type
    when "move"
    when "chat"
    else
      return nil
    end
  end
  
end
