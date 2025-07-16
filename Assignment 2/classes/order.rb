class Order
  attr_accessor :product_id, :customer_name, :credit_card_number, :quantity

  def initialize(product_id, customer_name, credit_card_number, quantity)
    @product_id = product_id
    @customer_name = customer_name
    @credit_card_number = credit_card_number
    @quantity = quantity
    
  end

  def to_array
    [product_id, customer_name, credit_card_number, quantity]
  end
end