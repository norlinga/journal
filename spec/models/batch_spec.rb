# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Batch, type: :model do
  describe 'validations' do
    it 'is valid with a valid status' do
      batch = build(:batch, status: 'pending')
      expect(batch).to be_valid
    end

    it 'raises an error when status is invalid' do
      expect { build(:batch, status: 'invalid_status') }.to raise_error(ArgumentError)
    end
  end

  describe 'enums' do
    it 'defines the correct statuses' do
      expect(Batch.statuses.keys).to match_array(%w[pending processing completed failed])
    end
  end

  describe 'callbacks' do
    it 'sets default status to pending before validation' do
      batch = build(:batch, status: nil)
      batch.valid?
      expect(batch.status).to eq('pending')
    end
  end

  describe 'scopes' do
    let!(:batch1) { create(:batch, :completed, processed_at: 1.day.ago) }
    let!(:batch2) { create(:batch, :completed, processed_at: 2.days.ago) }
    let!(:batch3) { create(:batch, :failed, processed_at: 1.day.ago) }
    let!(:batch4) { create(:batch, :processing) }

    it 'returns the latest successful batch' do
      expect(Batch.latest_successful).to eq(batch1)
    end
  end
end
