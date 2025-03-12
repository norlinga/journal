# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order do
  describe 'basic functionality' do
    let(:order) { build(:order) }

    it 'can be saved to the database' do
      expect { order.save! }.not_to raise_error
    end

    it 'stores the raw CSV data' do
      order.save!
      expect(order.raw_data).to be_a(String)
      expect(order.raw_data).to include("order_id,ordered_at,item_type")
    end
  end
end
