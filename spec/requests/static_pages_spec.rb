require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /home" do
    it "returns http success" do
      get static_pages_home_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /help" do
    it "returns http success" do
      get static_pages_help_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get static_pages_about_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "title /home" do
    it "Homeがタイトルに含まれること" do
      get static_pages_home_path
      expect(response.body).to include "<title>Home</title>"
    end
  end

  describe "title /help" do
    it "Helpがタイトルに含まれること" do
      get static_pages_home_path
      expect(response.body).to include "<title>Help</title>"
    end
  end

  describe "title /About" do
    it "Aboutがタイトルに含まれること" do
      get static_pages_home_path
      expect(response.body).to include "<title>About</title>"
    end
  end
end
