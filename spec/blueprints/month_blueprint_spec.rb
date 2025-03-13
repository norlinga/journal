# frozen_string_literal: true

require "rails_helper"

RSpec.describe MonthBlueprint do
  describe "serialization" do
    let(:month_data) do
      {
        date_str: "2023-02",
        order_count: 42
      }
    end

    it "serializes a month correctly" do
      result = MonthBlueprint.render_as_hash(month_data)

      expect(result).to eq(
        {
          month: "February 2023",
          order_count: 42,
          link: "/api/journal/2023-02"
        }
      )
    end
  end
end
