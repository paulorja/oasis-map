module Gameplay
  class GameplayCmd

    attr_accessor :type, :params, :player, :world, :ws

    def initialize(type, params, player, world, ws = nil)
      @type = type
      @params = params
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
