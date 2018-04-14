module Gameplay
  class GameplayCmd

    attr_accessor :type, :params, :player, :world, :ws

    def initialize(msg_hash, player, world, ws = nil)
      @type = msg_hash['gameplay_name']
      @params = msg_hash['params'] 
      @player = player
      @world = world
      @ws = ws
    end

    def is_valid?
      is_valid_type? and is_valid_params?
    end

    def is_valid_type?
      %w(move chat).include? @type
    end

    def is_valid_params?
      @params.is_a? Hash
    end

  end
end
