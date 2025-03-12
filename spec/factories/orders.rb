FactoryBot.define do
  factory :order do
    association :batch
    external_order_id { rand(1..1000) }
    ordered_at { Time.parse("2023-01-23") }
    item_type { "Item_7" }
    price_per_item { 10.68 }
    quantity { 2 }
    shipping { 1.97 }
    tax_rate { 0.033 }

    payment_1_id { "04efdd47-9e4f-4da4-a41e-21d619e3f560" }
    payment_1_amount { 12.32 }
    payment_2_id { "7ac2a2b3-9b4d-442d-bbe7-d0327086db0e" }
    payment_2_amount { 11.71 }

    raw_data { "order_id,ordered_at,item_type,price_per_item,quantity,shipping,tax_rate,payment_1_id,payment_1_amount,payment_2_id,payment_2_amount\n#{external_order_id},#{ordered_at},#{item_type},#{price_per_item},2,1.97,0.033,04efdd47-9e4f-4da4-a41e-21d619e3f560,12.32,7ac2a2b3-9b4d-442d-bbe7-d0327086db0e,11.71" }
  end
end
