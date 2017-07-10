class Authentication

  def self.auth(json_msg, server, ws, world, players)
    player = Player.new(json_msg['nickname'], json_msg['body'])
    if player.is_valid?
      players[ws.object_id] = player
      server.subscribe_channel('all', ws)
      server.send ClientMessages.auth_success(player.character.nickname), ws
      server.send ClientMessages.init_world(world.height, world.width, world.part_of_world(0, 0, 10)), ws
      server.send ClientMessages.all_characters(players), ws
      world.add_character player.character
      server.channel_push('all', ClientMessages.add_character(player.character))
      puts "#{player.character.nickname} join"
    end
  end

end