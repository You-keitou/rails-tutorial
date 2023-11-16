require 'rails_helper'

RSpec.describe 'Following', type: :system, js: true do
  before do
    driven_by(:rack_test)
    @user1 = create(:testuser)
    log_in(@user1)
  end

  describe 'following' do
    it 'followingの数が正しく表示されていること' do
      send(:create_relationships!, user: @user1)
      visit following_user_path(@user1)
      expect(page).to have_selector 'div.stats', text: '10 following'
    end

    it 'フォローしているユーザーへのリンクが表示されていること' do
      send(:create_relationships!, user: @user1)
      visit following_user_path(@user1)
      @user1.following.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
      end
    end
  end

  describe 'followers' do
    it 'followersの数が正しく表示されていること' do
      send(:create_relationships!, user: @user1)
      visit followers_user_path(@user1)
      expect(page).to have_selector 'div.stats', text: '10 followers'
    end

    it 'フォロワーへのリンクが表示されていること' do
      send(:create_relationships!, user: @user1)
      visit followers_user_path(@user1)
      @user1.followers.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
      end
    end
  end
end
