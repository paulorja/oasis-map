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
            pos_to_move = self.world.get_shortest_border_cell(self, @follow_char)
            if pos_to_move
              msg = Gameplay::GameplayCmd.generate_msg('move', {
                'x' => pos_to_move[0], 
                'y' => pos_to_move[1]
              })
              Gameplay::MoveCharacter.new(msg, @npc_player, self.world).run
            else
              @follow_char = nil
            end
            @sleep = 0.1
          end
        elsif self.cell
          Log.log("NPC: #{self.nickname}")
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
