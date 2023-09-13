require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe 'GET /home' do
    it 'returns http success' do
      get home_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /help' do
    it 'returns http success' do
      get help_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /about' do
    it 'returns http success' do
      get about_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /contact' do
    it 'returns http success' do
      get contact_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /root' do
    it 'return http success' do
      get root_url
      expect(response).to have_http_status(:success)
    end
  end

  describe 'title /home' do
    it 'titleがRuby on Rails Tutorial Sample Appであること' do
      get home_path
      expect(response.body).to include "<title>#{base_title}</title>"
    end
  end

  describe 'title /help' do
    it 'Helpがタイトルに含まれること' do
      get help_path
      expect(response.body).to include "<title>Help | #{base_title}</title>"
    end
  end

  describe 'title /About' do
    it 'Aboutがタイトルに含まれること' do
      get about_path
      expect(response.body).to include "<title>About | #{base_title}</title>"
    end
  end

  describe 'title /Contact' do
    it 'Contactがタイトルに含まれること' do
      get contact_path
      expect(response.body).to include "<title>Contact | #{base_title}</title>"
    end
  end

end

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

