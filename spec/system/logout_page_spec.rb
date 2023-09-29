require 'rails_helper'

RSpec.describe 'logout e2eテスト', type: :system, js: true do
  let!(:user_attributes) { attributes_for(:testuser) }
  let!(:user) { create(:testuser, user_attributes) }
  before do
    driven_by :rack_test
  end
  describe 'logout' do
    context '一つのタブからログイン状態' do
      it 'ログアウトができること' do
        log_in_as(user_attributes)
        expect(page).to have_link 'Log out', href: logout_path
        click_link 'Log out'
        expect(page).not_to have_link 'Log out', href: logout_path
      end
    end

    # context '二つのタブからログイン状態' do
    #   it '一つのタブでログアウトすると、もう一つのタブでもログアウト状態になること' do
    #     # 二つ目のタブを開く
    #     switch_to_window open_new_window
    #     visit login_path
    #     fill_in_form(user_attributes, login_form: true)
    #     find('input[name="commit"]').click
    #     click_link 'Log out'
    #     # 一つ目のタブに戻って、ページを更新
    #     switch_to_window window[0]
    #     visit current_path
    #     expect(page).to have_link 'Log in', href: login_path
    #   end
    # end
  end
end
