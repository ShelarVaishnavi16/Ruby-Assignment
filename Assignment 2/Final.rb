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
  
  choice = nil
  loop do
    print "Choose an option (1-7): "
    choice = gets.chomp
    if choice.match?(/^[1-7]$/)
      break
    else
      puts "Invalid choice. Please enter a number between 1 and 7."
    end
  end

  case choice
  when '1'
    loop do
      print "Enter ID: "; id = gets.chomp
      if id.match?(/^[A-Za-z0-9]{1,10}$/)
        break
      else
        puts "Invalid ID. Must be 1-10 alphanumeric characters only."
      end
    end

    loop do
      print "Enter Name: "; name = gets.chomp
      if name.match?(/^[A-Za-z0-9\s\-\.]{2,50}$/) && !name.strip.empty?
        break
      else
        puts "Invalid name. Must be 2-50 characters, letters, numbers, spaces, hyphens, and dots only."
      end
    end

    loop do
      print "Enter Price: "; price = gets.chomp
      if price.match?(/^\d+(\.\d{1,2})?$/) && price.to_f > 0
        break
      else
        puts "Invalid price. Must be a positive number (e.g., 10.99)."
      end
    end

    loop do
      print "Enter Stock Quantity: "; stock = gets.chomp
      if stock.match?(/^\d+$/) && stock.to_i > 0
        break
      else
        puts "Invalid stock quantity. Must be a positive integer."
      end
    end

    loop do
      print "Enter Manufacturer: "; company = gets.chomp
      if company.match?(/^[A-Za-z0-9\s\-\.&]{2,30}$/) && !company.strip.empty?
        break
      else
        puts "Invalid manufacturer. Must be 2-30 characters, letters, numbers, spaces, hyphens, dots, and & only."
      end
    end

    inventory.create(Product.new(id, name, price, stock, company))
    puts "Product added."

  when '2'
    puts "\nAll Products:"
    inventory.all.each do |p|
      puts "#{p.id} | #{p.name} | Rs #{p.price} | Stock: #{p.stock_quantity} | #{p.manufacturer}"
    end

  when '3'
    loop do
      print "Enter ID to update: "; id = gets.chomp
      if id.match?(/^[A-Za-z0-9]{1,10}$/)
        break
      else
        puts "Invalid ID format. Must be 1-10 alphanumeric characters only."
      end
    end

    product = inventory.find_product(id)
    if product
      loop do
        print "Enter New Name: "; name = gets.chomp
        if name.match?(/^[A-Za-z0-9\s\-\.]{2,50}$/) && !name.strip.empty?
          break
        else
          puts "Invalid name. Must be 2-50 characters, letters, numbers, spaces, hyphens, and dots only."
        end
      end

      loop do
        print "Enter New Price: "; price = gets.chomp
        if price.match?(/^\d+(\.\d{1,2})?$/) && price.to_f > 0
          break
        else
          puts "Invalid price. Must be a positive number (e.g., 10.99)."
        end
      end

      loop do
        print "Enter New Stock: "; stock = gets.chomp
        if stock.match?(/^\d+$/) && stock.to_i >= 0
          break
        else
          puts "Invalid stock quantity. Must be a non-negative integer."
        end
      end

      loop do
        print "Enter New Manufacturer: "; company = gets.chomp
        if company.match?(/^[A-Za-z0-9\s\-\.&]{2,30}$/) && !company.strip.empty?
          break
        else
          puts "Invalid manufacturer. Must be 2-30 characters, letters, numbers, spaces, hyphens, dots, and & only."
        end
      end

      inventory.update(Product.new(id, name, price, stock, company))
      puts "Product updated."
    else
      puts "Product not found."
    end

  when '4'
    loop do
      print "Enter ID to delete: "; id = gets.chomp
      if id.match?(/^[A-Za-z0-9]{1,10}$/)
        break
      else
        puts "Invalid ID format. Must be 1-10 alphanumeric characters only."
      end
    end
    
    inventory.delete(id)
    puts "Product deleted."

  when '5'
    pid = nil
    loop do
      print "Enter Product ID to order: "; pid = gets.chomp
      if pid.match?(/^[A-Za-z0-9]{1,10}$/)
        break
      else
        puts "Invalid ID format. Must be 1-10 alphanumeric characters only."
      end
    end

    product = inventory.find_product(pid)
    if product.nil?
      puts "Product not found."
      next
    end

    cname = nil
    loop do
      print "Enter Your Name: "; cname = gets.chomp
      if cname.match?(/^[A-Za-z\s\-\.]{2,50}$/) && !cname.strip.empty?
        break
      else
        puts "Invalid name. Must be 2-50 characters, letters, spaces, hyphens, and dots only."
      end
    end

    cc = ''
    loop do
      print "Enter Credit Card Number: "; cc = gets.chomp
      if cc.match?(/^\d{12,19}$/)
        break
      else
        puts "Invalid card number. It must be between 12 to 19 digits."
      end
    end

    qty = nil
    loop do
      print "Enter Quantity: "; qty_input = gets.chomp
      if qty_input.match?(/^\d+$/) && qty_input.to_i > 0
        qty = qty_input.to_i
        break
      else
        puts "Invalid quantity. Must be a positive integer."
      end
    end

    if product.stock_quantity.to_i < qty
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
  end
end