require 'csv'

# The seeds here is just for us to get a real pass through of the Batch+Order import process

module Colors
  RED    = "\e[31m"
  GREEN  = "\e[32m"
  YELLOW = "\e[33m"
  BLUE   = "\e[34m"
  RESET  = "\e[0m"
end

# This is where I checked out the `interview-fullstack` repo
csv_path = Rails.root.join('../interview-fullstack/data.csv')

unless File.exist?(csv_path)
  puts "#{Colors::RED}ERROR: CSV file not found at #{csv_path}. Please ensure the file exists.#{Colors::RESET}"
  exit
end

puts "#{Colors::BLUE}Starting order import from CSV: #{csv_path}#{Colors::RESET}"

batch = Batch.create!(status: 'pending')

CSV.foreach(csv_path, headers: true) do |row|
  Order.create!(
    batch: batch,
    external_order_id: row['order_id'].to_i,
    ordered_at: Time.parse(row['ordered_at']),
    item_type: row['item_type'],
    price_per_item: row['price_per_item'].to_d,
    quantity: row['quantity'].to_i,
    shipping: row['shipping'].to_d,
    tax_rate: row['tax_rate'].to_d,
    payment_1_id: row['payment_1_id'].presence,
    payment_1_amount: row['payment_1_amount'].to_d.presence,
    payment_2_id: row['payment_2_id'].presence,
    payment_2_amount: row['payment_2_amount'].to_d.presence,
    raw_data: row.to_h.to_json # Store full row as JSON for reference
  )
end

batch.update!(status: 'completed', processed_at: Time.current)

latest_batch = Batch.latest_successful
order_count = latest_batch.orders.count

puts "#{Colors::GREEN}Import complete! #{order_count} orders imported in Batch ##{latest_batch.id}.#{Colors::RESET}"
