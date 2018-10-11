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
        Thread.current["name"] = "npc"
        @sleep = 1
        if @follow_char
          unless is_moving
            distance = self.world.distance_of(
              self.current_pos[0], self.current_pos[1],
              @follow_char.current_pos[0], @follow_char.current_pos[1]
            )
            if distance.to_f == 1.0
              msg = Gameplay::GameplayCmd.generate_msg('character_action', {
                'char_id' => @follow_char.object_id 
              })
              Gameplay::CharacterAction.new(msg, @npc_player, self.world).run
              @sleep = 0.9
            else
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
          end
        elsif self.cell
          if @npc_player.config["move"]
            msg = Gameplay::GameplayCmd.generate_msg('move', {
              'x' => self.current_pos[0]+1-rand(3), 
              'y' => self.current_pos[1]+1-rand(3)
            })
            Gameplay::MoveCharacter.new(msg, @npc_player, self.world).run
            @sleep += rand
          end
        end
        sleep @sleep 
      end
    end
  end

end
