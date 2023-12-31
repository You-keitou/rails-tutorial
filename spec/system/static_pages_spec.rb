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
  let(:base_user_attributes) do
    {
      name: 'keito',
      email: 'k.you@example.jp',
      password: '123456',
      password_confirmation: '123456'
    }
  end

  describe 'root' do
    it 'root_pathへのリンクが二つ、help、about、contactへのリンクが表示されていること' do
      visit root_path
      signup_link = page.find_all("a[href=\"#{signup_path}\"]")

      expect(signup_link.size).to eq 1
      expect(page).to have_link 'sample app', href: root_path
      expect(page).to have_link 'Home', href: root_path
      expect(page).to have_link 'Help', href: help_path
      expect(page).to have_link 'Contact', href: contact_path
      expect(page).to have_link 'About', href: about_path
    end
  end

  describe 'Home' do
    let(:user) { create(:testuser) }
    before do
      send(:create_testpost, user: user, posts_count: 35)
      log_in(user)
      visit root_path
    end

    it 'ページネーションのラッパータグが表示されていること' do
      expect(page).to have_selector 'div.pagination'
    end

    context '有効なマイクロポストが投稿された時' do
      it '投稿が一件増えること' do
        fill_in 'micropost[content]', with: 'Lorem ipsum'
        expect do
          click_button 'Post'
        end.to change(Micropost, :count).by(1)
      end
    end

    context '無効なマイクロポストが投稿された時' do
      it '投稿が増えないこと' do
        expect do
          click_button 'Post'
        end.to change(Micropost, :count).by(0)
      end
    end

    context '投稿の削除ボタンを押した時' do
      it '投稿が一件減ること' do
        expect(page).to have_link 'delete'
        expect do
          click_link 'delete', href: micropost_path(user.microposts.first)
        end.to change(Micropost, :count).by(-1)
      end
    end

    it '投稿件数が35件と表示されていること' do
      expect(page).to have_selector 'span', text: '35 microposts'
    end

    it '投稿に画像が添付できること' do
      expect do
        fill_in 'micropost[content]', with: 'Lorem ipsum'
        attach_file 'micropost[picture]', "#{Rails.root}/spec/factories/test.jpg"
        click_button 'Post'
      end.to change(Micropost, :count).by(1)

      visit root_path
      expect(page).to have_selector 'img'
    end
  end

end
