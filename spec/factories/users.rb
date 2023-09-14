FactoryBot.define do
  factory :testuser, class: User do
    sequence(:name) { |i| "name#{i}"}
    sequence(:email) { |i| "#{i}@example.com"}
  end
end
