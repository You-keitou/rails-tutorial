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
end
