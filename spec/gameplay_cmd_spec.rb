require './lib/gameplay_cmd'

RSpec.describe "Gameplay Command" do

  before :context do 
    @move = GameplayCmd.new("move", {to_x: 5, to_y: 10})
    @chat = GameplayCmd.new("chat", {message: "hello!"})
   
    @not_valid_gameplay = GameplayCmd.new("moveX", 5)
  end

  it "move" do
    expect(@move.is_valid?).to be true
  end

  it "chat" do
    expect(@chat.is_valid?).to be true
  end

  it "not valid gameplay" do
    expect(@not_valid_gameplay.is_valid?).to be false
  end

end
