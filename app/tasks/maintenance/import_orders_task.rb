# frozen_string_literal: true

module Maintenance
  class ImportOrdersTask < MaintenanceTasks::Task
    CSV_BATCH_SIZE = 20
    CSV_PATH = Rails.root.join("data.csv")

    attr_accessor :batch_id

    after_complete :update_batch_status

    def initialize
      super
      @batch_id = Batch.create!(status: "pending").id
    end

    def collection
      CSV.open(CSV_PATH, headers: true).each_slice(CSV_BATCH_SIZE).to_a
    end

    def process(batch_of_rows)
      orders = create_orders(batch_of_rows)
      create_journal_entries(orders)
    end

    private

    def create_orders(batch_of_rows)
      result = ProcessCsvToOrders.call(batch_id: batch_id, csv_rows: batch_of_rows)

      if result.failure?
        fail_batch("Order processing failed: #{result.error}")
      end

      insert_and_return_orders(result.orders)
    end

    def create_journal_entries(orders)
      journal_entries = []

      orders.each do |order|
        result = ProcessOrderToJournalEntries.call(order: order)

        if result.success?
          journal_entries.concat(result.journal_entries)
        else
          fail_batch("Journal entry processing failed for Order #{order.id}: #{result.error}")
        end
      end

      JournalEntry.insert_all(journal_entries) if journal_entries.any?
    end

    def fail_batch(error_message)
      Batch.find(batch_id).update!(status: "failed")
      fail error_message
    end

    def update_batch_status
      Batch.find(batch_id).update!(status: "completed", processed_at: Time.current) if batch_id.present?
    end

    def insert_and_return_orders(orders)
      before_count = Order.count
      Order.insert_all(orders)
      inserted_count = Order.count - before_count
      Order.order(id: :desc).limit(inserted_count)
    end
  end
end
