require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe 'GET /signup' do
    it 'returns http success' do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'post /signup' do
    context '無効なユーザー' do
      let(:user_params) {  build(:testuser).attributes  }
      it 'DBに登録されない' do
        expect {
          post signup_path, params: {
            user: user_params
          }
        }.to change{User.count}.by(1)
      end
    end
  end

  describe 'title /signup' do
    it "title が #{full_title('Sign up')}となっていること" do
      get signup_path
      expect(response.body).to include("<title>#{full_title('Sign up')}</title>")
    end
  end
end
