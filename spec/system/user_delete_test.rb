require 'rails_helper'

RSpec.describe 'ユーザー削除ボタン', type: :system, js: true do
  before do
    driven_by(:rack_test)
  end

  describe 'ユーザーボタンの機能' do
    context '一般ユーザーとしてログインしているとき' do
      let(:user) { create(:testuser) }
      it 'ユーザー削除ボタンが表示されないこと' do
        log_in(user)
        visit users_path
        User.paginate(page: 1).each do |user|
          expect(page).not_to have_link 'delete', href: user_path(user)
        end
      end
    end

    context '管理者としてログインしているとき' do
      let!(:admin) { create(:testuser, admin: true) }
      let!(:testuser) { create(:testuser) }
      # ここに関しても！をつけないと、テストが通らない
      it 'ユーザー削除ボタンが表示されること' do
        log_in(admin)
        visit users_path
        User.paginate(page: 1).each do |user|
          expect(page).to have_link 'delete', href: user_path(user) if user != admin
        end
      end
      it 'ユーザーを削除できること' do
        log_in(admin)
        visit users_path
        expect { click_link 'delete', href: user_path(testuser) }.to change { User.count }.by(-1)
      end
    end
  end
end
