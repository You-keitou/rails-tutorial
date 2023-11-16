require 'rails_helper'

def fill_in_login_form(user_attributes)
  fill_in 'session[email]', with: user_attributes[:email]
  fill_in 'session[password]', with: user_attributes[:password]
end

RSpec.describe 'login_page e2eテスト', type: :system, js: true do
  before do
    driven_by(:rack_test)
  end

  describe 'loginフォーム' do
    context '入力が無効であるとき' do
      let!(:invalid_user_attributes) do
        {
          email: 'k.you@ingage.jp',
          password: '222'
        }
      end
      it 'エラーが表示されること' do
        visit login_path
        fill_in_login_form invalid_user_attributes
        click_button 'Log in'
        expect(page).to have_selector 'div', class: 'alert-danger'
      end

      it 'エラーが表示され、別のページに移動したとき、エラーは消えていること' do
        visit login_path
        fill_in_login_form invalid_user_attributes
        click_button 'Log in'
        click_on 'Home'
        expect(page).not_to have_selector 'div', class: 'alert-danger'
      end

      it 'ページ遷移が行われないこと' do
        visit login_path
        fill_in_login_form invalid_user_attributes
        click_button 'Log in'
        expect(current_path).to eq(login_path)
      end
    end

    context '入力が有効であること' do
      let!(:new_user) do
        User.create({
                      name: 'keito',
                      email: 'youkeitou327@gmail.com',
                      password: '123456',
                      password_confirmation: '123456',
                      activated: true,
                      activated_at: Time.zone.now
                    })
      end
      it 'フォワードフォーディングが成功すること' do
        visit users_path
        fill_in_login_form({
                             email: new_user.email,
                             password: '123456'
                           })
        expect { click_button 'Log in' }.to change { current_path }.from(login_path).to(users_path)
      end
    end
  end
end
