# frozen_string_literal: true

class JournalSummaryBlueprint < Blueprinter::Base
  field :account_type
  field :entry_type
  field :total do |entry|
    format("%.2f", entry.total / 100.0) # Convert cents to dollars
  end
end
