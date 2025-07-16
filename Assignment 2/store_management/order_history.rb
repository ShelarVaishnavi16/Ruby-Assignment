require 'csv'
require_relative '../classes/order'

class OrderHistory
  FILE_PATH = 'data/orders.csv'

  def initialize
    create_file unless File.exist?(FILE_PATH)
  end

  def all
    CSV.read(FILE_PATH, headers: true).map do |row|
        Order.new(*row.fields)
    end
  end

  def record(order)
    CSV.open(FILE_PATH, 'a') do |csv|
      csv << order.to_array
    end
  end

  private

  def create_file
    CSV.open(FILE_PATH, 'w') do |csv|
      csv << %w[product_id customer_name credit_card_number quantity]
    end
  end
end