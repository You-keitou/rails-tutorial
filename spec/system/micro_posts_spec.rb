require 'rails_helper'

RSpec.describe 'Microposts', type: :system, js: true do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:testuser) }

  describe 'ユーザーの一覧ページ' do
    before do
      log_in(user)
    end
    it '30件のマイクロポストが表示されること' do
      send(:create_testpost, user: user, posts_count: 35)
      visit user_path(user)
      post_list = within 'ol.microposts' do
        find_all 'li'
      end
      expect(post_list.size).to eq 30
    end

    it 'タイトルが正しく表示されること' do
      visit user_path(user)
      expect(page).to have_title full_title(user.name)
    end

    it 'ユーザー名が正しく表示されること' do
      visit user_path(user)
      expect(page).to have_selector 'h1', text: user.name
    end

    it 'ユーザーアバターが表示されること' do
      visit user_path(user)
      expect(page).to have_selector 'h1>img.gravatar'
    end

    it 'ページネーションが表示されること' do
      send(:create_testpost, user: user, posts_count: 35)
      visit user_path(user)
      expect(page).to have_selector 'div.pagination'
    end
  end
end
