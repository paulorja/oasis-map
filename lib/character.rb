class Character

  attr_accessor :nickname, :cell

  def initialize(nickname)
    @nickname = nickname
    @cell = nil
  end

  def client_data
  	{
  		nickname: nickname
  	}
  end

end
