# frozen_string_literal: true

class MonthBlueprint < Blueprinter::Base
  field :month do |month|
    Date.strptime(month[:date_str], "%Y-%m").strftime("%B %Y")
  end

  field :order_count
  field :link do |month|
    "/api/journal/#{month[:date_str]}"
  end
end
