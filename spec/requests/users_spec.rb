require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:base_title) {'Ruby on Rails Tutorial Sample App'}

  describe "GET /signup" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "title /signup" do
    it "title が #{full_title('Sign up')}となっていること" do
      get signup_path
      expect(response.body).to include("<title>#{full_title('Sign up')}</title>")
    end
  end
end
