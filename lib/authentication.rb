class Authentication

  def self.auth(json_msg, server, ws, world, players)
    player = Player.new(json_msg['nickname'], json_msg['body_style'])
    if player.is_valid?
      players[ws.object_id] = player
      server.subscribe_channel('all', ws)
      server.send ClientMessages.auth_success(player.character.nickname), ws

      player.character.inventory.add world.items[1]
      player.character.inventory.add world.items[3]
      player.character.inventory.add world.items[8]
      player.character.inventory.add world.items[9]

      server.send ClientMessages.inventory(player.character.inventory), ws
      player.character.refresh_craft_list
      server.send ClientMessages.refresh_craft_list(player.character.craft_list), ws
      server.send ClientMessages.init_world(world.height, world.width, world.part_of_world(0, 0, 10)), ws
      server.send ClientMessages.all_characters(players), ws
      world.add_character player.character
      server.channel_push('all', ClientMessages.add_character(player.character))
      server.channel_push('all',
        ClientMessages.global_chat(
          {nickname: 'Server', chat_message: "#{player.character.nickname} entrou."}))


      world.get_cell(124, 124).set_unit 0
      world.get_cell(127, 124).set_unit 0
      world.get_cell(124, 127).set_unit 3
      world.get_cell(127, 127).set_unit 3
      server.channel_push('all', ClientMessages.refresh_cell(world.get_cell(124, 124)))
      server.channel_push('all', ClientMessages.refresh_cell(world.get_cell(127, 124)))
      server.channel_push('all', ClientMessages.refresh_cell(world.get_cell(124, 127)))
      server.channel_push('all', ClientMessages.refresh_cell(world.get_cell(127, 127)))
    end
  end

end
