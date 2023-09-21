require 'rails_helper'

RSpec.describe 'logout e2eテスト', type: :system, js: true do
  before do
    driven_by(:rack_test)
  end
  describe 'logout' do
    context 'ログインしている状態' do
      let!(:user_attributes) { attributes_for(:testuser) }
      let!(:user) { create(:testuser, user_attributes) }
      it 'ログアウトができること' do
        visit login_path
        fill_in_form(user_attributes, login_form: true)
        find('input[name="commit"]').click
        expect(page).to have_link 'Log out', href: logout_path
        click_link 'Log out'
        expect(page).not_to have_link 'Log out', href: logout_path
      end
    end
  end
end
