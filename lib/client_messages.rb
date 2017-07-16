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
        characters_array << player[1].character.client_data
      end
    end
    JsonMsg.success({message: 'all_characters', characters: characters_array})
  end

  def self.add_character(character)
    JsonMsg.success({message: 'add_character', character: character.client_data })
  end

  def self.remove_character(character)
    JsonMsg.success({message: 'remove_character', nickname: character.nickname })
  end

  def self.refresh_character(character)
    JsonMsg.success({message: 'refresh_character', character: character.client_data })
  end

  def self.auth_success(nickname)
  	JsonMsg.success({message: 'auth_success', nickname: nickname})
  end

  def self.inventory(inventory)
    JsonMsg.success({message: 'inventory', inventory: inventory.to_client})
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

  def self.refresh_craft_list(craft_list)
    JsonMsg.success({
        message: 'refresh_craft_list',
        craft_list: craft_list
    })
  end

  def self.global_chat(config)
    JsonMsg.success({
      message: 'global_chat',
      nickname: config[:nickname],
      chat_message: config[:chat_message]
    })
  end

  def self.craft_info(info)
    JsonMsg.success({
      message: 'craft_info',
      craft_info: info
    })
  end

end
