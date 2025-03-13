# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::Journals", type: :request do
  let!(:batch) { create(:batch, :completed, processed_at: Time.current) }
  let!(:order) { create(:order, batch: batch, ordered_at: "2023-02-15") }
  let!(:journal_entry) { create(:journal_entry, order: order, batch: batch, account_type: "revenue", entry_type: "credit", amount: 156451) }

  describe "GET /months" do
    it "returns http success" do
      get "/api/journal/months"
      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json["months"]).to be_an(Array)
      expect(json["months"].first).to have_key("month")
      expect(json["months"].first).to have_key("order_count")
      expect(json["months"].first).to have_key("link")
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/api/journal/2023-02"
      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json["journal_summary"]).to be_an(Array)
      expect(json["journal_summary"].first["account_type"]).to eq("revenue")
      expect(json["journal_summary"].first["entry_type"]).to eq("credit")
      expect(json["journal_summary"].first["total"]).to eq("1564.51") # Convert cents to dollars
    end
  end
end
