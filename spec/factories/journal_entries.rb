FactoryBot.define do
  factory :journal_entry do
    association :batch
    association :order
    account_type { JournalEntry.account_types.keys.sample }
    amount { rand(100..10_000) }
    entry_type { JournalEntry.entry_types.keys.sample }
    balanced { true }
  end
end
