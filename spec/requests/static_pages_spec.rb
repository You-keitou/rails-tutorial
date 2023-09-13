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
      expect(response.body).to include "<title>#{full_title}</title>"
    end
  end

  describe 'title /help' do
    it 'Helpがタイトルに含まれること' do
      get help_path
      expect(response.body).to include "<title>#{full_title('Help')}</title>"
    end
  end

  describe 'title /About' do
    it 'Aboutがタイトルに含まれること' do
      get about_path
      expect(response.body).to include "<title>#{full_title('About')}</title>"
    end
  end

  describe 'title /Contact' do
    it 'Contactがタイトルに含まれること' do
      get contact_path
      expect(response.body).to include "<title>#{full_title('Contact')}</title>"
    end
  end
end
