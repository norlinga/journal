# frozen_string_literal: true

class Api::JournalController < ApplicationController
  before_action :set_latest_batch

  def months
    return render json: { months: [] } if @batch.nil?

    months = fetch_months
    render json: MonthBlueprint.render(months, root: :months)
  end

  def show
    return render json: { error: "Month is required" }, status: :bad_request unless params[:month]

    summary = fetch_journal_summary(params[:month])
    render json: JournalSummaryBlueprint.render(summary, root: :journal_summary)
  end

  private

  def set_latest_batch
    @batch = Batch.latest_successful
  end

  def fetch_months
    Order
      .where(batch_id: @batch.id)
      .group(Arel.sql("strftime('%Y-%m', ordered_at)"))
      .pluck(Arel.sql("strftime('%Y-%m', ordered_at)"), Arel.sql("COUNT(*)"))
      .map { |date_str, count| { date_str: date_str, order_count: count } }
  end

  def fetch_journal_summary(month)
    JournalEntry
      .joins(:order)
      .where(orders: { batch_id: @batch.id })
      .where(Arel.sql("strftime('%Y-%m', orders.ordered_at) = ?"), month)
      .group(:account_type, :entry_type)
      .select("account_type, entry_type, SUM(amount) AS total")
  end
end
