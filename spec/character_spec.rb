require './lib/character'

RSpec.describe "character" do
  
  before :context do 
    @character = Character.new
  end

  describe "attributes" do
    it "not empty" do 
      expect(@character.nickname).not_to be_empty
      expect(@character.world).not_to be_empty
    end
  end  

  describe "actions" do
    it "move" do
      @character.move(3, 6)
    end

  end

end
