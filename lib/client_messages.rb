class ClientMessages

  def self.change_object_world(object)
    JsonMsg.success({message: 'change_object_world', object: object})    
  end

  def self.part_of_world(part_of_world)
    JsonMsg.success({message: 'part_of_world', part_of_world: part_of_world})
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

end
