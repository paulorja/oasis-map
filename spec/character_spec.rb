require './lib/character'
require './lib/inventory'
require './lib/world'

RSpec.describe "character" do
  
  before :context do 
    @character = Character.new('joao', '1')
  end

  describe "attributes" do
    it "not empty" do 
      expect(@character.nickname).not_to be_empty
    end

    it "get atk" do
      expect(@character.get_atk).to be(1)
    end
  end  

  describe "actions" do
    it "move" do

    end

    it "character increment attr" do
      
    end
  end

end
