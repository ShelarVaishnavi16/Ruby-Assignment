require 'csv'
require_relative '../classes/product'

class ProductInventory
  FILE_PATH = 'data/products.csv'

  def initialize
    create_file unless File.exist?(FILE_PATH)
  end

  def all
    CSV.read(FILE_PATH, headers: true).map do |row|
      Product.new(*row.fields)
    end
  end

  def find_product(id)
    all.find { |product| product.id == id.to_s }
  end

  def create(product)
    CSV.open(FILE_PATH, 'a') do |csv|
      csv << product.to_array
    end
  end

  def update(updated_product)
    updated_list = all.map do |product|
      product.id == updated_product.id ? updated_product : product
    end
    write_all(updated_list)
  end

  def delete(id)
    filtered = all.reject { |product| product.id == id.to_s }
    write_all(filtered)
  end

  def reduce_stock(product_id, quantity)
    products = all
    product = products.find { |p| p.id == product_id }
    return false unless product && product.stock_quantity.to_i >= quantity

    product.stock_quantity = (product.stock_quantity.to_i - quantity).to_s
    update(product)
    true
  end

  private

  def write_all(products)
    CSV.open(FILE_PATH, 'w') do |csv|
      csv << %w[id name price stock_quantity manufacturer]
      products.each { |product| csv << product.to_array }
    end
  end

  def create_file
    CSV.open(FILE_PATH, 'w') do |csv|
      csv << %w[id name price stock_quantity manufacturer]
    end
  end
end