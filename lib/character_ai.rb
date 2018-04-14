class CharacterAI < Character

  def initialize(nickname, body_style, npc_player)
    super(nickname, body_style)
    @npc_player = npc_player
    start_ai_thread
  end

  def start_ai_thread
    Thread.new do 
      loop do
        begin
          Log.log("NPC: #{self.nickname}")
          if self.cell
            Gameplay::MoveCharacter.new('move', { 'x' => self.current_pos[0]+1-rand(3), 'y' => self.current_pos[1]+1-rand(3)}, @npc_player, self.world).run
          end
        rescue Exception => e
          puts e.message  
          puts e.backtrace.inspect
        end
        sleep 1
      end
    end
  end

end
