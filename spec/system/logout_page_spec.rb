require 'rails_helper'

def fill_in_login_form(user_attributes)
  fill_in 'session[email]', with: user_attributes[:email]
  fill_in 'session[password]', with: user_attributes[:password]
end

RSpec.describe 'logout e2eテスト', type: :system, js: true do
  let!(:user_attributes) { attributes_for(:testuser) }
  let!(:user) { create(:testuser, user_attributes) }
  before do
    driven_by :rack_test
  end
  let(:base_user_attributes) do
    {
      name: 'keito',
      email: 'keitou@gmail.com',
      password: '123456',
      password_confirmation: '123456',
      activated: true,
      activated_at: Time.zone.now
    }
  end
  describe 'logout' do
    context 'ログインしている状態' do
      let!(:user) { User.create(base_user_attributes) }
      it 'ログアウトができること' do
        visit login_path
        fill_in_login_form base_user_attributes
        find('input[name="commit"]').click
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
