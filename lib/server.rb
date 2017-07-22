require 'em-websocket'
require 'json'
require 'colorize'
require 'chingu_pathfinding'
require 'set'

require './lib/json_msg'
require './lib/client_messages'
require './lib/log'
require './lib/world'
require './lib/cell'
require './lib/player'
require './lib/character'
require './lib/gameplay/gameplay_cmd'
require './lib/gameplay/move_character'
require './lib/gameplay/cell_action'
require './lib/gameplay/take_cell_drops'
require './lib/gameplay/global_chat'
require './lib/gameplay/use_item'
require './lib/gameplay/remove_equip'
require './lib/gameplay/craft'
require './lib/gameplay/request_craft'
require './lib/gameevent/gameevent'
require './lib/gameevent/event_seed'
require './lib/gameevent/spawn_unit'
require './lib/game_object_loader'
require './lib/world_loader'
require './lib/world_creator'
require './lib/pathfinding_generator'
require './lib/authentication'
require './lib/inventory'

TERRAINS = GameObjectLoader.load_terrains
UNITS = GameObjectLoader.load_units
UNIT_SPAWNS = GameObjectLoader.load_unit_spawns

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
          @world.resolve_events self

          case json_msg['message']
          when 'auth'
            if @players[ws.object_id].nil?
              Authentication.auth(json_msg, self, ws, @world, @players)
            else
              puts 'you already auth'
            end
          when 'gameplay'
            if @players[ws.object_id].nil?
              puts 'you cant do this'
            else
              @world.gameplay json_msg, @players[ws.object_id], self, ws
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
          channel_push('all',
            ClientMessages.global_chat(
              {nickname: 'Server', chat_message: "#{character.nickname} saiu."}))
          channel_push('all', ClientMessages.remove_character(character))
          @players.delete ws.object_id
        end
        Log.log 'Connection Close'
      }
    end
  end

  def send(msg, ws)
    Log.send(msg[0, 1000])
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
