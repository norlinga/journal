# frozen_string_literal: true

require "rails_helper"

RSpec.describe Maintenance::ImportOrdersTask do
  describe "successful processing" do
    it "creates a new Batch and processes orders correctly" do
      perform_enqueued_jobs do
        MaintenanceTasks::Runner.run(name: "Maintenance::ImportOrdersTask")
      end

      expect(Batch.last.status).to eq("completed")

      expect(Order.count).to be 100
      expect(JournalEntry.count).to be 800
    end
  end
end
