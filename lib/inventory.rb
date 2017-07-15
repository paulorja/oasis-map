class Inventory

  def initialize
    @items = []
  end

  def all
    @items
  end

  def add(item)
    @items.unshift item
  end

  def remove(item)
    @items.delete_at @items.index item
  end

  def remove_by_id(id)
    @items.each_with_index do |item, index|
      if item['public']['id'] == id
        @items.delete_at index
        break
      end
    end
  end

  def to_client
    @items.map { |i| i['public'] }
  end

  def find_item(item_id)
    @items.each do |item|
      return item if item['public']['id'] == item_id
    end
    nil
  end

  def exist_item?(item_id)
    @items.each do |item|
      return true if item['public']['id'] == item_id
    end
    false
  end

end