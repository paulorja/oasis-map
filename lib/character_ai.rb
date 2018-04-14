class CharacterAI < Character

  attr_accessor :follow_char

  def initialize(nickname, body_style, npc_player)
    super(nickname, body_style)
    @npc_player = npc_player
    @follow_char = nil
    start_ai_thread
  end

  def start_ai_thread
    Thread.new do 
      loop do
        @sleep = 1
        if @follow_char
          unless is_moving
            msg = Gameplay::GameplayCmd.generate_msg('move', {
              'x' => @follow_char.current_pos[0], 
              'y' => @follow_char.current_pos[1]
            })
            Gameplay::MoveCharacter.new(msg, @npc_player, self.world).run
            @sleep = 0.1
          end
        elsif self.cell
          #Log.log("NPC: #{self.nickname}")
          msg = Gameplay::GameplayCmd.generate_msg('move', {
            'x' => self.current_pos[0]+1-rand(3), 
            'y' => self.current_pos[1]+1-rand(3)
          })
          Gameplay::MoveCharacter.new(msg, @npc_player, self.world).run
        end
        sleep @sleep + rand
      end
    end
  end

end
