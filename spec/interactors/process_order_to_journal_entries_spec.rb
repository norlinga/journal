# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessOrderToJournalEntries do
  let(:batch) { create(:batch) }
  let(:order) { create(:order, batch: batch, price_per_item: 10.68, quantity: 2, shipping: 1.97, tax_rate: 0.033, payment_1_amount: 12.32, payment_2_amount: 11.71) }

  describe "successful processing" do
    it "returns journal entries and marks them balanced if correct" do
      result = ProcessOrderToJournalEntries.call(order: order)

      expect(result).to be_success
      expect(result.journal_entries).to be_an(Array)
      expect(result.journal_entries.size).to eq(8)

      total_revenue = (order.price_per_item * 100).to_i * order.quantity
      total_tax = (total_revenue * order.tax_rate).round
      total_credits = (order.payment_1_amount * 100).to_i + (order.payment_2_amount * 100).to_i

      revenue_entry = result.journal_entries.find { |e| e[:account_type] == "revenue" }
      expect(revenue_entry[:amount]).to eq(total_revenue)

      tax_entry = result.journal_entries.find { |e| e[:account_type] == "sales_tax_payable" }
      expect(tax_entry[:amount]).to eq(total_tax)

      cash_entry = result.journal_entries.find { |e| e[:account_type] == "cash" }
      expect(cash_entry[:amount]).to eq(total_credits)

      expect(result.balanced).to be true
    end
  end

  describe "handling errors" do
    it "fails if no order is provided" do
      result = ProcessOrderToJournalEntries.call(order: nil)
      expect(result).to be_failure
      expect(result.error).to be_a(String)
      expect(result.error).to eq("Order is required")
    end
  end
end
