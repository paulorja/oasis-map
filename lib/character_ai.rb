class CharacterAI < Character

  def initialize(nickname, body_style, npc_player)
    super(nickname, body_style)
    @npc_player = npc_player
    start_ai_thread
  end

  def start_ai_thread
    Thread.new do 
      loop do
        #Log.log("NPC: #{self.nickname}")
        sleep 1
      end
    end
  end

end
