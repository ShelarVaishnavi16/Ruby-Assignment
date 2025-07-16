class Product
  attr_accessor :id, :name, :price, :stock_quantity, :manufacturer

  def initialize(id, name, price, stock_quantity, manufacturer)
    @id = id
    @name = name
    @price = price
    @stock_quantity = stock_quantity
    @manufacturer = manufacturer
  end

  def to_array
    [id, name, price, stock_quantity, manufacturer]
  end
end