FactoryBot.define do
  factory :action do
    activity_type { 'accept' }
    actor { 'https://example.com/actor/example_actor' }
    object { '{}' }
  end
end
