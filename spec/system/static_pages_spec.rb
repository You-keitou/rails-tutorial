require 'rails_helper'

RSpec.describe 'StaticPages', type: :system, js: true do
  before do
    driven_by(:rack_test)
    @invalid_user_factory_params = [
      [:email_invalid_character],
      [:email_length_variable, { email_length: 256 }],
      [:username_length_variable, { name_length: 51 }],
      [:non_password_user],
      [:password_length_variable, { password_length: 5 }]
    ]
  end

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
    context '無効なユーザーが送信されたとき' do
      let(:user_attributes) { attributes_for(:testuser, *@invalid_user_factory_params.sample) }
      it 'エラーが表示される' do
        visit signup_path
        fill_in_form(user_attributes)
        find('input[name="commit"]').click
        expect(page).to have_content(/The form contains [0-9]+ errors*./)
      end

      it 'ユーザーは登録されない' do
        visit signup_path
        fill_in_form(user_attributes)
        expect do
          find('input[name="commit"]').click
        end.to change { User.count }.by(0)
      end
    end

    context '有効なユーザーが送信されたとき' do
      let(:user_attributes) { attributes_for(:testuser) }
      it 'ユーザーが登録される' do
        visit signup_path
        p user_attributes
        fill_in_form(user_attributes)
        expect do
          click_button 'Create my account'
        end.to change(User, :count).by(1)
      end
      it 'リダイレクトされる' do
        visit signup_path
        fill_in_form(user_attributes)
        find('input[name="commit"]').click
        expect(current_path).to eq(user_path(User.find_by(email: user_attributes[:email])))
      end
      it '成功のflashが出る' do
        visit signup_path
        fill_in_form(user_attributes)
        find('input[name="commit"]').click
        expect(page).to have_selector 'div', class: 'alert-success'
      end
    end
  end
end
