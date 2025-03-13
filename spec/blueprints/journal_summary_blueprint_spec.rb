# frozen_string_literal: true

require "rails_helper"

RSpec.describe JournalSummaryBlueprint do
  describe "serialization" do
    let(:journal_entry) do
      OpenStruct.new(
        account_type: "revenue",
        entry_type: "credit",
        total: 156451 # Stored in cents
      )
    end

    it "serializes a journal entry correctly" do
      result = JournalSummaryBlueprint.render_as_hash(journal_entry)

      expect(result).to eq(
        {
          account_type: "revenue",
          entry_type: "credit",
          total: "1564.51" # Formatted to dollars
        }
      )
    end
  end
end
