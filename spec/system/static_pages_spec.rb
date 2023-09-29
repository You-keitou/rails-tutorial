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
end
