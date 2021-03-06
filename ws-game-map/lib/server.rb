require 'em-websocket'
require 'json'
require 'colorize'
require 'chingu_pathfinding'
require 'set'
require 'byebug'

require './configs/configs_loader'
require './lib/json_msg'
require './lib/client_messages'
require './lib/log'
require './lib/world'
require './lib/cell'
require './lib/player'
require './lib/character'
require './lib/character_ai'
require './lib/npc'
require './lib/gameplay/gameplay_cmd'
require './lib/gameplay/move_character'
require './lib/gameplay/cell_action'
require './lib/gameplay/character_action'
require './lib/gameplay/take_cell_drops'
require './lib/gameplay/global_chat'
require './lib/gameplay/character_data'
require './lib/gameplay/use_item'
require './lib/gameplay/remove_equip'
require './lib/gameplay/craft'
require './lib/gameplay/increment_char_attr'
require './lib/gameplay/request_craft'
require './lib/gameevent/gameevent'
require './lib/gameevent/event_seed'
require './lib/gameevent/spawn_unit'
require './lib/world_loader'
require './lib/pathfinding_generator'
require './lib/authentication'
require './lib/inventory'

Thread.current["name"] = "server"
TERRAINS = ConfigsLoader.load_terrains
UNITS = ConfigsLoader.load_units
UNIT_SPAWNS = ConfigsLoader.load_unit_spawns
NPCS = ConfigsLoader.load_npcs
WORLD_NAME = "default_world"

class Server

  def initialize
  end

  def start
  	@world = World.new(self)
  	@players = {}
    @world.npcs.each do |npc|
      @players[npc.object_id] = npc
      @world.add_character(npc.character, @world.get_cell(npc.start_x, npc.start_y))
    end
    create_channel('all')
    start_resolve_events

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

          Log.info "[received]" + ": #{msg}"

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
              @world.gameplay json_msg, @players[ws.object_id], @world, ws
            end
          else
            Log.info "gameplay not found: #{msg}"
          end
        rescue => exception
          Log.alert exception.backtrace
        end
	  }
    
      ws.onclose {
        # remove player from world
        if @players[ws.object_id]
          character = @players[ws.object_id].character
          channel_push('all',
            ClientMessages.global_chat(
              {nickname: 'Server', chat_message: "#{character.nickname} saiu."}))
          channel_push('all', ClientMessages.remove_character(character.object_id))

          @players.each do |key, player|
            if player.character.is_a? CharacterAI and player.character.follow_char == @players[ws.object_id].character
              player.character.follow_char = nil
            end
          end

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

  def start_resolve_events
    Thread.new do
      loop do
        @world.resolve_events self
        #Log.log('resolving events')
        sleep 1 
      end
    end
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
