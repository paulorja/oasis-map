class GameplayCmd

  attr_reader :type, :params

  def initialize(type, params)
    @type = type
    @params = params
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
