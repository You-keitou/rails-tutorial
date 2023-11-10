require 'rails_helper'

def fill_in_login_form(user_attributes)
  fill_in 'session[email]', with: user_attributes[:email]
  fill_in 'session[password]', with: user_attributes[:password]
end

RSpec.describe 'logout e2eテスト', type: :system, js: true do
  before do
    driven_by(:rack_test)
  end
  let(:base_user_attributes) do
    {
      name: 'keito',
      email: 'keitou@gmail.com',
      password: '123456',
      password_confirmation: '123456'
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
  end
end
