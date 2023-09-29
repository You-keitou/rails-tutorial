require 'rails_helper'

# RSpect helper
def fill_in_form(user_data)
  fill_in 'user[name]', with: user_data[:name]
  fill_in 'user[email]', with: user_data[:email]
  fill_in 'user[password]', with: user_data[:password]
  fill_in 'user[password_confirmation]', with: user_data[:password_confirmation]
end

RSpec.describe 'StaticPages', type: :system, js: true do
  before do
    driven_by(:rack_test)
  end
  let(:base_user_attributes) {
  {
    name: 'keito',
    email: 'k.you@example.jp',
    password: '123456',
    password_confirmation: '123456'
  }}

  describe 'root' do
    it 'root_pathへのリンクが二つ、help、about、contactへのリンクが表示されていること' do
      visit root_path
      signup_link = page.find_all("a[href=\"#{signup_path}\"]")

      expect(signup_link.size).to eq 2
      expect(page).to have_link 'sample app', href: root_path
      expect(page).to have_link 'Home', href: home_path
      expect(page).to have_link 'Help', href: help_path
      expect(page).to have_link 'Contact', href: contact_path
      expect(page).to have_link 'About', href: about_path
    end
  end

  describe 'signup page' do
    shared_context '無効なユーザーを入力する' do |invalid_attr, invalid_attr_value|
      if invalid_attr != :password
        let(:invalid_user_attributes) {{
          invalid_attr => invalid_attr_value,
          **base_user_attributes.except(invalid_attr)
        }}
      else
        let(:invalid_user_attributes) {{
          password: invalid_attr_value,
          password_confirmation: invalid_attr_value,
          **base_user_attributes.except(:password, :password_confirmation)
        }}
      end
    end

    shared_examples 'エラーが発生する' do
      it 'エラーが表示される' do
        visit signup_path
        fill_in_form(invalid_user_attributes)
        find('input[name="commit"]').click
        expect(page).to have_content('The form contains 1 error.')
      end

      it 'ユーザーは登録されない' do
        visit signup_path
        fill_in_form(invalid_user_attributes)
        expect do
          find('input[name="commit"]').click
        end.to change { User.count }.by(0)
      end
    end

    context '名前が無効なユーザーが送信されたとき' do
      include_context '無効なユーザーを入力する', :name, 'a' * 51
      it_behaves_like 'エラーが発生する'
    end

    context 'メールアドレスが無効なユーザーが送信されたとき' do
      include_context '無効なユーザーを入力する', :email, 'a' * 244 + '@example.com'
      it_behaves_like 'エラーが発生する'
    end

    context 'パスワードが無効なユーザーが送信されたとき' do
      include_context '無効なユーザーを入力する', :password, 'a' * 5
      it_behaves_like 'エラーが発生する'
    end

    context '有効なユーザーが送信されたとき' do
      it 'ユーザーが登録される' do
        visit signup_path
        fill_in_form(base_user_attributes)
        expect do
          click_button 'Create my account'
        end.to change(User, :count).by(1)
      end
      it 'リダイレクトされる' do
        visit signup_path
        fill_in_form(base_user_attributes)
        find('input[name="commit"]').click
        expect(current_path).to eq(user_path(User.find_by(email: base_user_attributes[:email])))
      end
      it '成功のflashが出る' do
        visit signup_path
        fill_in_form(base_user_attributes)
        find('input[name="commit"]').click
        expect(page).to have_selector 'div', class: 'alert-success'
      end
    end
  end
end
