require 'rails_helper'

RSpec.describe 'ユーザー編集ページ', type: :system, js: true do
  before do
    driven_by(:rack_test)
  end

  describe 'ログインしている状態' do
    let(:user1) { create(:testuser) }
    let(:user2) { create(:testuser) }
    context '正しいユーザーであるとき' do
      it '正しいパラメーターを与えら時に、updateできること' do
        log_in(user1)
        visit edit_user_path(user1)
        fill_in_edit_form(user1)
        expect { click_button 'Save changes' }.to change {
                                                    current_path
                                                  }.from(edit_user_path(user1)).to(user_path(user1))
        expect(page).to have_selector 'div', class: 'alert-success'
      end
    end
    context '正しくユーザーである時（他のユーザーの編集ページにアクセスしている）' do
      it 'rootページにリダイレクトされること' do
        log_in(user1)
        visit edit_user_path(user2)
        expect(current_path).to eq root_path
      end
      it 'flashが表示されること' do
        log_in(user1)
        visit edit_user_path(user2)
        expect(page).to have_selector 'div', class: 'alert-danger'
      end
    end
    context 'ログインしていない時' do
      it 'ログインページにリダイレクトされること' do
        visit edit_user_path(user1)
        expect(current_path).to eq login_path
      end
      it 'flashが表示されること' do
        visit edit_user_path(user1)
        expect(page).to have_selector 'div', class: 'alert-danger'
      end
      it 'ログインした後に、編集画面にフレンドリーフォワーディングされること' do
        visit edit_user_path(user1)
        expect(current_path).to eq login_path
        log_in(user1)
        expect(current_path).to eq edit_user_path(user1)
      end
    end
  end
end
