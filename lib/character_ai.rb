class CharacterAI < Character

  def initialize(nickname, body_style, npc_player)
    super(nickname, body_style)
    @npc_player = npc_player
    @target_character = nil
    
    start_ai_thread
  end

  def start_ai_thread
    Thread.new do 
      loop do
        Log.log("NPC: #{self.nickname}")
        if self.cell
          msg = Gameplay::GameplayCmd.generate_msg('move', {
            'x' => self.current_pos[0]+1-rand(3), 
            'y' => self.current_pos[1]+1-rand(3)
          })
          Gameplay::MoveCharacter.new(msg, @npc_player, self.world).run
        end
        sleep 1
      end
    end
  end

end
