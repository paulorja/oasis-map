class Authentication

  def self.auth(json_msg, server, ws, world, players)
    player = Player.new(json_msg['nickname'], json_msg['body_style'])
    if player.is_valid?
      players[ws.object_id] = player
      server.subscribe_channel('all', ws)
      server.send ClientMessages.auth_success(player.character.nickname), ws

      player.character.inventory.add world.items[1]
      player.character.inventory.add world.items[3]
      player.character.inventory.add world.items[4]
      player.character.inventory.add world.items[5]
      player.character.inventory.add world.items[7]
      player.character.inventory.add world.items[8]
      player.character.inventory.add world.items[9]
      player.character.inventory.add world.items[10]
      player.character.inventory.add world.items[11]
      player.character.inventory.add world.items[12]
      player.character.inventory.add world.items[13]
  	  player.character.inventory.add world.items[14]
      player.character.inventory.add world.items[15]
      player.character.inventory.add world.items[16]
      player.character.inventory.add world.items[17]

      world.get_cell(62, 64).unit = world.units[2]
      world.get_cell(64, 64).unit = world.units[2]
      world.get_cell(62, 66).unit = world.units[3]
      world.get_cell(64, 66).unit = world.units[3]
      server.channel_push('all', ClientMessages.refresh_cell(world.get_cell(62, 64)))
      server.channel_push('all', ClientMessages.refresh_cell(world.get_cell(64, 64)))
      server.channel_push('all', ClientMessages.refresh_cell(world.get_cell(62, 66)))
      server.channel_push('all', ClientMessages.refresh_cell(world.get_cell(64, 66)))


      server.send ClientMessages.inventory(player.character.inventory), ws
      server.send ClientMessages.init_world(world.height, world.width, world.part_of_world(0, 0, 10)), ws
      server.send ClientMessages.all_characters(players), ws
      world.add_character player.character
      server.channel_push('all', ClientMessages.add_character(player.character))
      server.channel_push('all',
        ClientMessages.global_chat(
          {nickname: 'Server', chat_message: "#{player.character.nickname} entrou."}))
      puts "#{player.character.nickname} join"
    end
  end

end
