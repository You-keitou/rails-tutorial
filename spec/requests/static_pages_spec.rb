require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe 'GET /home' do
    it 'returns http success' do
      get static_pages_home_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /help' do
    it 'returns http success' do
      get static_pages_help_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /about' do
    it 'returns http success' do
      get static_pages_about_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /contact' do
    it 'returns http success' do
      get static_pages_contact_path
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
      get static_pages_home_path
      expect(response.body).to include "<title>#{base_title}</title>"
    end
  end

  describe 'title /help' do
    it 'Helpがタイトルに含まれること' do
      get static_pages_help_path
      expect(response.body).to include "<title>Help | #{base_title}</title>"
    end
  end

  describe 'title /About' do
    it 'Aboutがタイトルに含まれること' do
      get static_pages_about_path
      expect(response.body).to include "<title>About | #{base_title}</title>"
    end
  end

  describe 'title /Contact' do
    it 'Contactがタイトルに含まれること' do
      get static_pages_contact_path
      expect(response.body).to include "<title>Contact | #{base_title}</title>"
    end
  end
end
