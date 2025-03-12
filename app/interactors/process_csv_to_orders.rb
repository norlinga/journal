# frozen_string_literal: true

class ProcessCsvToOrders
  include Interactor

  def call
    context.fail!(error: "Batch ID is required") unless context.batch_id.present?
    context.fail!(error: "CSV rows are required") unless context.csv_rows.present?

    orders = []

    context.csv_rows.each do |row|
      orders << {
        batch_id: context.batch_id,
        external_order_id: row["order_id"].to_i,
        ordered_at: Time.parse(row["ordered_at"]),
        item_type: row["item_type"],
        price_per_item: row["price_per_item"].to_d,
        quantity: row["quantity"].to_i,
        shipping: row["shipping"].to_d,
        tax_rate: row["tax_rate"].to_d,
        payment_1_id: row["payment_1_id"].presence,
        payment_1_amount: row["payment_1_amount"].to_d.presence,
        payment_2_id: row["payment_2_id"].presence,
        payment_2_amount: row["payment_2_amount"].to_d.presence,
        raw_data: row.to_h.to_json
      }
    end

    context.orders = orders
  end
end
