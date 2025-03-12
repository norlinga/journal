# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProcessCsvToOrders, type: :interactor do
  let(:batch) { create(:batch) }
  let(:csv_rows) do
    [
      {
        "order_id" => "1",
        "ordered_at" => "2023-01-23",
        "item_type" => "Item_7",
        "price_per_item" => "10.68",
        "quantity" => "2",
        "shipping" => "1.97",
        "tax_rate" => "0.033",
        "payment_1_id" => "04efdd47-9e4f-4da4-a41e-21d619e3f560",
        "payment_1_amount" => "12.32",
        "payment_2_id" => "7ac2a2b3-9b4d-442d-bbe7-d0327086db0e",
        "payment_2_amount" => "11.71"
      }
    ]
  end

  describe "successful processing" do
    it "processes CSV rows and returns structured order hashes" do
      result = ProcessCsvToOrders.call(batch_id: batch.id, csv_rows: csv_rows)

      expect(result).to be_success
      expect(result.orders).to be_an(Array)
      expect(result.orders.size).to eq(1)

      order = result.orders.first
      expect(order[:batch_id]).to eq(batch.id)
      expect(order[:external_order_id]).to eq(1)
      expect(order[:price_per_item]).to eq(10.68.to_d)
      expect(order[:quantity]).to eq(2)
      expect(order[:raw_data]).to be_a(String)
    end
  end

  describe "handling errors" do
    it "fails if no batch ID is provided" do
      result = ProcessCsvToOrders.call(batch_id: nil, csv_rows: csv_rows)
      expect(result).to be_failure
      expect(result.error).to eq("Batch ID is required")
    end

    it "fails if no CSV rows are provided" do
      result = ProcessCsvToOrders.call(batch_id: batch.id, csv_rows: nil)
      expect(result).to be_failure
      expect(result.error).to eq("CSV rows are required")
    end
  end
end
