class ClientMessages

  def self.change_object_world(object)
    JsonMsg.success({message: 'change_object_world', object: object})    
  end

  def self.part_of_world(part_of_world)
    JsonMsg.success({message: 'part_of_world', part_of_world: part_of_world})
  end

  def self.all_characters(players)
    characters_array = []
    players.each do |player|
      if player[1].character and player[1].character.cell
        characters_array << {
          nickname: player[1].character.nickname,
          x: player[1].character.cell.x,
          y: player[1].character.cell.y
        }
      end
    end
    JsonMsg.success({message: 'all_characters', characters: characters_array})
  end

  def self.add_character(character)
    JsonMsg.success({
      message: 'add_character',
      nickname: character.nickname,
      x: character.cell.x,
      y: character.cell.y
    })
  end

  def self.remove_character(character)
    JsonMsg.success({
      message: 'remove_character',
      nickname: character.nickname
    })
  end

  def self.move_character(character)
    JsonMsg.success({
      message: 'move_character',
      nickname: character.nickname,
      to_x: character.cell.x,
      to_y: character.cell.y
    })
  end

  def self.auth_success
  	JsonMsg.success({message: 'auth_success'})
  end

  def self.init_world(height, width, part_of_world)
  	JsonMsg.success({
  		message: 'init_world',
  		height: height,
  		width: width,
  		part_of_world: part_of_world 
	  })
  end

  def self.refresh_cell(cell)
    JsonMsg.success({
      message: 'refresh_cell',
      cell: cell.client_data  
    })
  end

  def self.global_chat(config)
    JsonMsg.success({
      message: 'global_chat',
      nickname: config[:nickname],
      chat_message: config[:chat_message]
    })
  end

end
