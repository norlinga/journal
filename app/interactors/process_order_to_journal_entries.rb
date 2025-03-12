# frozen_string_literal: true

class ProcessOrderToJournalEntries
  include Interactor

  def call
    context.fail!(error: "Order is required") unless context.order.present?

    context.batch = context.order.batch

    normalize_values
    calculate_totals

    context.balanced = (context.total_debits == context.total_credits)

    context.journal_entries = generate_journal_entries
  end

  private

  def normalize_values
    context.price_per_item = (context.order.price_per_item * 100).to_i
    context.shipping = (context.order.shipping * 100).to_i
    context.payment_1_amount = context.order.payment_1_amount ? (context.order.payment_1_amount * 100).to_i : 0
    context.payment_2_amount = context.order.payment_2_amount ? (context.order.payment_2_amount * 100).to_i : 0
    context.quantity = context.order.quantity
    context.tax_rate = context.order.tax_rate
  end

  def calculate_totals
    context.total_revenue = context.price_per_item * context.quantity
    context.total_tax = (context.total_revenue * context.tax_rate).round
    context.total_debits = context.total_revenue + context.shipping + context.total_tax
    context.total_credits = context.payment_1_amount + context.payment_2_amount
  end

  def generate_journal_entries
    [
      { batch_id: context.batch.id, order_id: context.order.id, account_type: "accounts_receivable", amount: context.total_revenue, entry_type: "debit", balanced: context.balanced },
      { batch_id: context.batch.id, order_id: context.order.id, account_type: "revenue", amount: context.total_revenue, entry_type: "credit", balanced: context.balanced },

      { batch_id: context.batch.id, order_id: context.order.id, account_type: "accounts_receivable", amount: context.shipping, entry_type: "debit", balanced: context.balanced },
      { batch_id: context.batch.id, order_id: context.order.id, account_type: "shipping_revenue", amount: context.shipping, entry_type: "credit", balanced: context.balanced },

      { batch_id: context.batch.id, order_id: context.order.id, account_type: "accounts_receivable", amount: context.total_tax, entry_type: "debit", balanced: context.balanced },
      { batch_id: context.batch.id, order_id: context.order.id, account_type: "sales_tax_payable", amount: context.total_tax, entry_type: "credit", balanced: context.balanced },

      { batch_id: context.batch.id, order_id: context.order.id, account_type: "cash", amount: context.total_credits, entry_type: "debit", balanced: context.balanced },
      { batch_id: context.batch.id, order_id: context.order.id, account_type: "accounts_receivable", amount: context.total_credits, entry_type: "credit", balanced: context.balanced }
    ]
  end
end
