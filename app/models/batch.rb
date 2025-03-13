# frozen_string_literal: true

class Batch < ApplicationRecord
  has_many :orders, dependent: :destroy

  enum :status, { pending: "pending", processing: "processing", completed: "completed", failed: "failed" }

  before_validation :set_default_status, on: :create

  validates :status, presence: true, inclusion: { in: statuses.keys }

  scope :latest_successful, -> { where(status: :completed).order(processed_at: :desc).first }

  private

  def set_default_status
    self.status ||= "pending"
  end
end
