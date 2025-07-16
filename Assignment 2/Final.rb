require_relative 'store_management/product_inventory'
require_relative 'store_management/order_history'
require_relative 'classes/product'
require_relative 'classes/order'

inventory = ProductInventory.new
orders = OrderHistory.new

loop do
  puts "\nMenu"
  puts "1. Add Product"
  puts "2. View Products"
  puts "3. Update Product"
  puts "4. Delete Product"
  puts "5. Place Order"
  puts "6. View Orders"
  puts "7. Exit"
  print "Choose an option: "
  choice = gets.chomp

  case choice
  when '1'
    print "Enter ID: "; id = gets.chomp
    print "Enter Name: "; name = gets.chomp
    print "Enter Price: "; price = gets.chomp
    print "Enter Stock Quantity: "; stock = gets.chomp
    print "Enter Manufacturer: "; company = gets.chomp
    inventory.create(Product.new(id, name, price, stock, company))
    puts "Product added."

  when '2'
    puts "\nAll Products:"
    inventory.all.each do |p|
      puts "#{p.id} | #{p.name} | Rs #{p.price} | Stock: #{p.stock_quantity} | #{p.manufacturer}"
    end

  when '3'
    print "Enter ID to update: "; id = gets.chomp
    product = inventory.find(id)
    if product
      print "Enter New Name: "; name = gets.chomp
      print "Enter New Price: "; price = gets.chomp
      print "Enter New Stock: "; stock = gets.chomp
      print "Enter New Manufacturer: "; company = gets.chomp
      inventory.update(Product.new(id, name, price, stock, company))
      puts "Product updated."
    else
      puts "Product not found."
    end

  when '4'
    print "Enter ID to delete: "; id = gets.chomp
    inventory.delete(id)
    puts "Product deleted."

  when '5'
    print "Enter Product ID to order: "; pid = gets.chomp
    product = inventory.find(pid)
    if product.nil?
      puts "Product not found."
      next
    end

    print "Enter Your Name: "; cname = gets.chomp
    cc = ''
    loop do
      print "Enter Credit Card Number: "; cc = gets.chomp
      if cc.match?(/^\d{12,19}$/)
        break
      else
        puts "Invalid card number. It must be between 12 to 19 digits."
      end
    end

     print "Enter Quantity: "; qty = gets.chomp.to_i
    if qty <= 0
      puts "Invalid quantity."
      next
    elsif product.stock_quantity.to_i < qty
      puts "Only #{product.stock_quantity} in stock. Cannot order #{qty}."
      next
    end

    orders.record(Order.new(pid, cname, cc, qty))
    inventory.reduce_stock(pid, qty)
    puts "Order placed. Stock updated."


  when '6'
    puts "\nAll Orders:"
    orders.all.each do |order|
      puts "Product ID: #{order.product_id} | Customer: #{order.customer_name}"
    end

  when '7'
    puts "Exiting..."
    break

  else
    puts "Invalid option."
  end
end