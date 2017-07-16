class Character

  attr_accessor :nickname, :cell, :inventory, :right_hand, :body, :head, :face, :cooldown, :craft_exp

  def initialize(nickname, body_style)
    @nickname = nickname
    @cell = nil
    @start_move_at = Time.now.to_f
    @end_move_at = Time.now.to_f
    @cooldown = Time.now.to_f
    @pathfinding = nil
    @speed = 0.6
    @body_style = body_style
    # equip
    @right_hand = nil
    @body = nil
    @head = nil
    @face = nil
    #
    @inventory = Inventory.new
    #
    @craft_exp = 0
  end

  def client_data
  	{
  		nickname: nickname,
      pathfinding: @pathfinding,
      time_to_move: diff_move,
      cell: cell.client_data,
      speed: @speed,
      body_style: @body_style,
      x: @cell.x,
      y: @cell.y,
      head: @head == nil ? nil : @head['public'],
      body: @body == nil ? nil : @body['public'],
      right_hand: @right_hand == nil ? nil : @right_hand['public'],
      face: @face == nil ? nil : @face['public']
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
      [@cell.x, @cell.y]
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

  def valid_body_style
    %w(1 2 3 4 5 6).include? @body_style
  end

  def equip(item)
    if item['public']['equip_on']
      case item['public']['equip_on']
      when 'right_hand'
        inventory.add @right_hand unless @right_hand.nil?
        @right_hand = item
      when 'head'
        inventory.add @head unless @head.nil?
        @head = item
      when 'body'
        inventory.add @body unless @body.nil?
        @body = item
      when 'face'
        inventory.add @face unless @face.nil?
        @face = item
      else
        false
      end
      true
    end
  end

  def remove_equip(item)
    if @right_hand and @right_hand['public']['id'] == item['public']['id']
      @right_hand = nil
      return true
    end
    if @body and @body['public']['id'] == item['public']['id']
      @body = nil
      return true
    end
    if @head and @head['public']['id'] == item['public']['id']
      @head = nil
      return true
    end
    if @face and @face['public']['id'] == item['public']['id']
      @face = nil
      return true
    end
    false
  end

  def find_equip(item_id)
    return @right_hand if @right_hand and @right_hand['public']['id'] == item_id
    return @body if @body and @body['public']['id'] == item_id
    return @head if @head and @head['public']['id'] == item_id
    return @face if @face and @face['public']['id'] == item_id
    false
  end

  def is_action_collision?(x, y)
    pos = current_pos
    return true if pos[0] == x and pos[1] == y
    if (x == pos[0]) ^ (y == pos[1])
      return true if pos[0] == x and pos[1] +1 == y
      return true if pos[0] == x and pos[1] -1 == y
      return true if pos[1] == y and pos[0] +1 == x
      return true if pos[1] == y and pos[0] -1 == x
    end
  end

  def is_cooldown_ok
    Time.now.to_f > @cooldown
  end

  def is_moving
    @end_move_at > Time.now.to_f
  end

  def craft_list
    craft_list = []
    craft_list += GameObjectLoader.load_craft 1
    craft_list += GameObjectLoader.load_craft 2 if @craft_exp > 150
    craft_list
  end

end
