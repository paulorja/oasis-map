module Gameplay
  class GameplayCmd

    attr_accessor :type, :params, :server, :player, :world, :ws

    def initialize(type, params, server, player, world, ws)
      @type = type
      @params = params
      @server = server
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
