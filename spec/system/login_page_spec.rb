require 'rails_helper'

RSpec.describe 'login_page' do
  before do
    driven_by(:rack_test)
  end

  describe 'login page' do
    context '入力が無効であるとき' do
      let!(:new_user_attributes) { attributes_for(:testuser) }
      it 'エラーが表示されること' do
        visit login_path
        fill_in_form(new_user_attributes, login_form: true)
        click_button 'Log in'
        expect(page).to have_selector 'div', class: 'alert-danger'
      end

      it 'エラーが表示され、別のページに移動したとき、エラーは消えていること' do
        visit login_path
        fill_in_form(new_user_attributes, login_form: true)
        click_button 'Log in'
        click_on 'Home'
        expect(page).not_to have_selector 'div', class: 'alert-danger'
      end
    end

    context '入力が有効であること' do
      let!(:new_user_attributes) { attributes_for(:testuser) }
      let!(:new_user) {create(:testuser, new_user_attributes)}
      it 'ユーザーページにリダイレクトされること' do
        visit login_path
        fill_in_form(new_user_attributes, login_form: true)
        expect{click_button 'Log in'}.to change{current_path}.from(login_path).to(user_path(new_user))
      end
    end
  end
end
