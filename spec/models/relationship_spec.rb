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
require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user1) { create(:testuser) }
  let(:user2) { create(:testuser) }
  let(:relationship) { Relationship.new(follower_id: user1.id, followed_id: user2.id) }
  describe 'バリデーション' do
    it 'follower_idとfollowed_idがあれば有効な状態であること' do
      expect(relationship).to be_valid
    end

    it 'follower_idがなければ無効な状態であること' do
      relationship.follower_id = nil
      expect(relationship).not_to be_valid
    end

    it 'followed_idがなければ無効な状態であること' do
      relationship.followed_id = nil
      expect(relationship).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'フォローが有効であること' do
      expect(user1.following).not_to include(user2)
      user1.follow!(user2)
      user1.reload
      expect(user1.following).to include(user2)
    end

    it 'フォロー解除が有効であること' do
      relationship.save
      user1.unfollow!(user2)
      user1.reload
      expect(user1.following).not_to include(user2)
    end
  end
end
