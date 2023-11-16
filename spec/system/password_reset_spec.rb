require 'rails_helper'

RSpec.describe 'パスワードリセットページテスト', type: :system, js: true do
  before do
    driven_by :rack_test
  end
  let(:user) {create(:testuser)}
  describe 'パスワードリセットページ' do
    context '正しいメールアドレスを入力したとき' do
      it 'リンクをクリックした時、フラッシュが出ること' do
        visit login_path
        click_link 'forgot password'
        fill_in 'Email', with: user.email
        click_button 'Submit'
        expect(page).to have_selector 'div', class: 'alert-info'
      end
      it 'パスワードの更新ができること' do
        user.create_reset_digest
        visit edit_password_reset_path(id: user.reset_token, email: user.email)
        fill_in 'Password', with: 'password'
        fill_in 'Confirmation', with: 'password'
        click_button 'Update password'
        expect(page).to have_selector 'div', class: 'alert-success'
      end
    end
    context '間違ったメールアドレスを入力した時' do
      it 'flashが出ること' do
        visit login_path
        click_link 'forgot password'
        fill_in 'Email', with: 'aaa@a.cn'
        click_button 'Submit'
        expect(page).to have_selector 'div', class: 'alert-danger'
      end
    end
  end
end
