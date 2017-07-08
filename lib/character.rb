class Character

  attr_accessor :nickname, :cell

  def initialize(nickname)
    @nickname = nickname
    @cell = nil
    @start_move_at = Time.now.to_f
    @end_move_at = Time.now.to_f
    @pathfinding = nil
    # tempo para atravessar um quadrado em linha reta
    @speed = 0.4
  end

  def client_data
  	{
  		nickname: nickname,
      pathfinding: @pathfinding,
      time_to_move: diff_move,
      cell: cell.client_data,
      speed: @speed
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

  def current_cell
    last_cell = nil
    quantidade_percorrida = Time.now.to_f
    @pathfinding.each do |cell|
      if last_cell
        if last_cell[0] != cell[0] and last_cell[1] != cell[1]
          quantidade_percorrida += Math.sqrt(2*@speed)
        else
          quantidade_percorrida += @speed
        end
        return cell if quantidade_percorrida > diff_move
      end
      last_cell = cell
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

end
