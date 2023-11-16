# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer
#  follower_id :integer
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
FactoryBot.define do
  factory :follower , class: Relationship do
    follower_id { 1 }
    followed_id { 1 }
  end

  factory :followed , class: Relationship do
    follower_id { 2 }
    followed_id { 2 }
  end
end

def create_relationships!(user:)
  10.times do |n|
    create(:testuser)
  end

  User.all.each do |other|
    next if other.id == user.id
    FactoryBot.create(:follower, follower_id: user.id, followed_id: other.id)
    FactoryBot.create(:followed, follower_id: other.id, followed_id: user.id)
  end
  # ここは user.follow!(other) にしてもいいと思ったが
end
