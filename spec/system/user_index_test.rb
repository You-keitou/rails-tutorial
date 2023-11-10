require 'rails_helper'

# frozen_string_literal: true

RSpec.describe 'ユーザー一覧ページ', type: :system, js: true do
  before do
    driven_by(:rack_test)
  end

  describe 'ログインしていない状態' do
    it 'ログインページにリダイレクトされること' do
      visit users_path
      expect(current_path).to eq login_path
    end
  end

  describe 'ログインしている状態' do
    before do
      30.times do
        create(:testuser)
      end
    end
    let(:user) { create(:testuser) }
    it 'paginationのボタンが表示されていること' do
      log_in(user)
      visit users_path
      expect(page).to have_selector 'div', class: 'pagination'
    end
    it 'ユーザーの表示数が制限されていること' do
      log_in(user)
      visit users_path
      User.paginate(page: 1).each do |user|
        expect(page).to have_link href: user_path(user)
      end
    end
  end
end
