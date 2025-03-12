# frozen_string_literal: true

class JournalEntry < ApplicationRecord
  belongs_to :batch
  belongs_to :order

  enum :entry_type, { debit: "debit", credit: "credit" }
  enum :account_type, {
    accounts_receivable: "accounts_receivable",
    revenue: "revenue",
    shipping_revenue: "shipping_revenue",
    sales_tax_payable: "sales_tax_payable",
    cash: "cash"
  }

  validates :account_type, presence: true
  validates :amount, numericality: { only_integer: true, greater_than: 0 }
  validates :entry_type, presence: true, inclusion: { in: entry_types.keys }
  validates :balanced, inclusion: { in: [ true, false ] }

  scope :balanced_entries, -> { where(balanced: true) }
  scope :debits, -> { where(entry_type: :debit) }
  scope :credits, -> { where(entry_type: :credit) }
end
