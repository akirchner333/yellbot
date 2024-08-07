FactoryBot.define do
  factory :note do
    content { "aaa" }
    letter { "a" }
    reply_actor { nil }
    reply_note { nil }
  end
end
