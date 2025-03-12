FactoryBot.define do
  factory :batch do
    status { 'pending' }
    processed_at { nil }

    trait :processing do
      status { 'processing' }
    end

    trait :completed do
      status { 'completed' }
      processed_at { Time.current }
    end

    trait :failed do
      status { 'failed' }
    end
  end
end
