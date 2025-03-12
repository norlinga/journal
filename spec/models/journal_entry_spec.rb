# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JournalEntry, type: :model do
  describe 'basic functionality' do
    let(:journal_entry) { build(:journal_entry) }

    it 'can be instantiated' do
      expect(journal_entry).to be_a(JournalEntry)
    end

    it 'can be saved to the database' do
      expect { journal_entry.save! }.not_to raise_error
    end
  end

  describe 'validations' do
    it 'is invalid without an account_type' do
      entry = build(:journal_entry, account_type: nil)
      expect(entry).not_to be_valid
      expect(entry.errors[:account_type]).to include("can't be blank")
    end

    it 'is invalid without an amount' do
      entry = build(:journal_entry, amount: nil)
      expect(entry).not_to be_valid
      expect(entry.errors[:amount]).to include("is not a number")
    end

    it 'is invalid with a non-integer amount' do
      entry = build(:journal_entry, amount: 12.34) # SQLite3 stores as integer
      expect(entry).not_to be_valid
      expect(entry.errors[:amount]).to include("must be an integer")
    end

    it 'is invalid with an unknown entry type' do
      expect { build(:journal_entry, entry_type: 'invalid_type') }.to raise_error(ArgumentError)
    end
  end

  describe 'scopes' do
    let!(:balanced_entry) { create(:journal_entry, balanced: true) }
    let!(:unbalanced_entry) { create(:journal_entry, balanced: false) }

    it 'returns only balanced entries' do
      expect(JournalEntry.balanced_entries).to include(balanced_entry)
      expect(JournalEntry.balanced_entries).not_to include(unbalanced_entry)
    end
  end
end
