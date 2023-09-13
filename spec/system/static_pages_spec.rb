require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'root' do
    it 'root_pathへのリンクが二つ、help、about、contactへのリンクが表示されていること' do
      visit root_path

      expect(page).to have_link 'sample app', href: root_path
      expect(page).to have_link 'Home', href: home_path
      expect(page).to have_link 'Help', href: help_path
      expect(page).to have_link 'Contact', href: contact_path
      expect(page).to have_link 'About', href: about_path
    end
  end
end