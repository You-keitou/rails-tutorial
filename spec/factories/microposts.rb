# == Schema Information
#
# Table name: microposts
#
#  id         :bigint           not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_microposts_on_user_id                 (user_id)
#  index_microposts_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :testpost, class: Micropost do
    content {Faker::Lorem.sentence}
    created_at {Faker::Time.between(from: 10.days.ago, to: Time.zone.now)}
  end

  factory :most_recent_post, class: Micropost do
    content {Faker::Lorem.sentence}
    created_at {Time.zone.now}
    user_id {User.first.id}
  end
end

def create_testpost(user: , posts_count: 10)
  FactoryBot.create_list(:testpost, posts_count, user: user)
end
