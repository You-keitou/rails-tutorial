# == Schema Information
#
# Table name: microposts
#
#  id         :bigint           not null, primary key
#  content    :text
#  picture    :string
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
require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { create(:testuser) }
  let(:micropost) { user.microposts.build(content: 'Lorem ipsum') }

  it '有効であること' do
    expect(micropost).to be_valid
  end

  it 'user_idがnilの場合、無効であること' do
    micropost.user_id = nil
    expect(micropost).not_to be_valid
  end

  describe 'content' do
    it '空白の場合、無効であること' do
      micropost.content = ' '
      expect(micropost).not_to be_valid
    end

    it '140文字を超える場合、無効であること' do
      micropost.content = 'a' * 141
      expect(micropost).not_to be_valid
    end
  end

  it '最新の投稿が最初に表示されること' do
    send(:create_testpost, user: user, posts_count: 10)
    expect(create(:most_recent_post)).to eq Micropost.first
  end

  it 'ユーザーを削除すると、関連する投稿も削除されること' do
    send(:create_testpost, user: user, posts_count: 1)
    expect { user.destroy }.to change { Micropost.count }.by(-1)
  end
end
