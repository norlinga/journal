# The seeds here is just for us to get a real pass through of the Batch+Order import process

module Colors
  RED    = "\e[31m"
  GREEN  = "\e[32m"
  YELLOW = "\e[33m"
  BLUE   = "\e[34m"
  RESET  = "\e[0m"
end

# This is where I checked out the `interview-fullstack` repo
csv_path = Rails.root.join('data.csv')

unless File.exist?(csv_path)
  puts "#{Colors::RED}ERROR: CSV file not found at #{csv_path}. Please ensure the file exists.#{Colors::RESET}"
  exit
end

puts "#{Colors::BLUE}Starting order import from CSV: #{csv_path}#{Colors::RESET}"

# -----------------------------------
# STEP 1: Create a Batch and Load Orders
# -----------------------------------

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

# -----------------------------------
# STEP 2: Process Orders → JournalEntries
# -----------------------------------

puts "#{Colors::BLUE}Processing orders into journal entries...#{Colors::RESET}"

orders = latest_batch.orders
journal_entries = []

orders.each do |order|
  # Normalize financial data to cents
  price_per_item = (order.price_per_item * 100).to_i
  shipping = (order.shipping * 100).to_i
  payment_1_amount = order.payment_1_amount ? (order.payment_1_amount * 100).to_i : 0
  payment_2_amount = order.payment_2_amount ? (order.payment_2_amount * 100).to_i : 0

  quantity = order.quantity
  tax_rate = order.tax_rate

  # Calculate derived values
  total_revenue = price_per_item * quantity
  total_tax = (total_revenue * tax_rate).round
  total_debits = total_revenue + shipping + total_tax
  total_credits = payment_1_amount + payment_2_amount

  # Determine if the order balances
  is_balanced = (total_debits == total_credits)

  journal_entries += [
    { batch_id: latest_batch.id, order_id: order.id, account_type: "accounts_receivable", amount: total_revenue, entry_type: "debit", balanced: is_balanced },
    { batch_id: latest_batch.id, order_id: order.id, account_type: "revenue", amount: total_revenue, entry_type: "credit", balanced: is_balanced },

    { batch_id: latest_batch.id, order_id: order.id, account_type: "accounts_receivable", amount: shipping, entry_type: "debit", balanced: is_balanced },
    { batch_id: latest_batch.id, order_id: order.id, account_type: "shipping_revenue", amount: shipping, entry_type: "credit", balanced: is_balanced },

    { batch_id: latest_batch.id, order_id: order.id, account_type: "accounts_receivable", amount: total_tax, entry_type: "debit", balanced: is_balanced },
    { batch_id: latest_batch.id, order_id: order.id, account_type: "sales_tax_payable", amount: total_tax, entry_type: "credit", balanced: is_balanced },

    { batch_id: latest_batch.id, order_id: order.id, account_type: "cash", amount: total_credits, entry_type: "debit", balanced: is_balanced },
    { batch_id: latest_batch.id, order_id: order.id, account_type: "accounts_receivable", amount: total_credits, entry_type: "credit", balanced: is_balanced }
  ]
end

JournalEntry.insert_all(journal_entries) if journal_entries.any?

puts "#{Colors::GREEN}Journal entry processing complete! #{journal_entries.size} entries created.#{Colors::RESET}"
