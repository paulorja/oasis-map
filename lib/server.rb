require 'em-websocket'
require 'json'
require 'colorize'
require 'chingu_pathfinding'

require './lib/json_msg'
require './lib/client_messages'
require './lib/log'
require './lib/world'
require './lib/cell'
require './lib/player'
require './lib/character'
require './lib/gameplay/gameplay_cmd'
require './lib/gameplay/move_character'
require './lib/gameplay/global_chat'
require './lib/pathfinding_generator'

class Server

  def initialize
  end

  def start
  	@world = World.new
  	@players = {}
    create_channel('all')

  	EventMachine::WebSocket.start(
      host: '0.0.0.0', 
      port: 5000
    ) do |ws|

      ws.onopen {
        Log.log 'Connection Open'
      }

      ws.onmessage { |msg|
        begin
          begin
            json_msg = JSON.parse(msg)
          rescue
            Log.alert "invalid json: #{msg}".red
          end

          Log.log "Received: #{msg}"

          case json_msg['message']
          when 'auth'
            if @players[ws.object_id].nil?
              player = Player.new(json_msg['nickname'])
              @players[ws.object_id] = player
              subscribe_channel('all', ws)
              send ClientMessages.auth_success, ws
              send ClientMessages.init_world(@world.height, @world.width, @world.part_of_world(0, 0, 10)), ws
              send ClientMessages.all_characters(@players), ws
              @world.add_character player.character
              channel_push('all', ClientMessages.add_character(player.character))
              puts "#{player.character.nickname} join"
            else
              puts 'you already auth'
            end
          when 'gameplay'
            if @players[ws.object_id].nil?
              puts 'you cant do this'
            else
              @world.gameplay json_msg, @players[ws.object_id], self
            end
          else
            puts 'not found'
          end
        rescue => exception
          puts exception.backtrace
        end
	  }
    
      ws.onclose {
        # remove player from world
        if @players[ws.object_id]
          character = @players[ws.object_id].character
          channel_push('all', ClientMessages.remove_character(character))
          @players.delete ws.object_id
        end
        Log.log 'Connection Close'
      }
    end
  end

  def send(msg, ws)
    Log.send(msg)
    ws.send msg
  end

  def channel_push(channel_id, msg)
    Log.push(msg)
    get_channel(channel_id)['channel'].push(msg)
  end

  def create_channel(channel_id)
    instance_variable_set("@channel_#{channel_id}", {"channel"=>EM::Channel.new,"queue"=>EM::Queue.new})
  end

  def subscribe_channel(channel_id, ws)
    get_channel(channel_id)["channel"].subscribe{ |msg| ws.send msg}
  end

  def get_channel(channel_id)
    instance_variable_get("@channel_#{channel_id}")
  end

end
