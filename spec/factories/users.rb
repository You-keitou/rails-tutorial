FactoryBot.define do
  factory :testuser, class: User do
    name {Faker::Name.last_name}
    email {Faker::Internet.free_email}
  end
end
