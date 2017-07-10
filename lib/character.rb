class Character

  attr_accessor :nickname, :cell, :body

  def initialize(nickname, body)
    @nickname = nickname
    @cell = nil
    @start_move_at = Time.now.to_f
    @end_move_at = Time.now.to_f
    @pathfinding = nil
    @speed = 0.6
    @body = body
  end

  def client_data
  	{
  		nickname: nickname,
      pathfinding: @pathfinding,
      time_to_move: diff_move,
      cell: cell.client_data,
      speed: @speed,
      body: @body,
      x: @cell.x,
      y: @cell.y,
  	}
  end

  def set_pathfinding(pathfinding)
    @start_move_at = Time.now.to_f
    @end_move_at = @start_move_at
    last_cell = nil
    pathfinding.each do |cell|
      if last_cell
        # se x e y são diferentes, então acrescenta diagonal
        if last_cell[0] != cell[0] and last_cell[1] != cell[1]
          @end_move_at += Math.sqrt(2) * @speed
        else
          @end_move_at += @speed
        end
      end
      last_cell = cell
    end
    @pathfinding = pathfinding
  end

  def current_pos
    if diff_move > 0
      last_cell = nil
      time = @start_move_at
      @pathfinding.each_with_index do |cell, index|
        if last_cell
          if last_cell[0] != cell[0] and last_cell[1] != cell[1]
            time += Math.sqrt(2) * @speed
          else
            time += @speed
          end
          if time > Time.now.to_f
            break
          end
        end
        last_cell = cell
      end
      last_cell
    else
      @cell
    end
  end

  def diff_move
    diff = @end_move_at - Time.now.to_f
    if diff > 0
      diff
    else
      0
    end
  end

  def valid_body
    %w(1 2 3 4 5 6).include? @body
  end

end
