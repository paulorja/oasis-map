require "./lib/player"

RSpec.describe "player" do

  before :context do
    @player = Player.new
  end

  it "has a char" do
    expect(@player.character).not_to be nil
  end

end
