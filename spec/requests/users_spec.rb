require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  before do
    @invalid_user_factory_params = [
      [:email_invalid_character],
      [:email_length_variable, { email_length: 256 }],
      [:username_length_variable, { name_length: 51 }],
      [:non_password_user],
      [:password_length_variable, { password_length: 5 }]
    ]
  end

  describe 'GET /signup' do
    it 'returns http success' do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'post /signup' do
    context '有効なユーザー' do
      let(:user_attributes) { attributes_for(:testuser) }
      it 'DBに登録される' do
        expect do
          post signup_path, params: {
            user: user_attributes
          }
        end.to change { User.count }.by(1)
      end
    end

    context '無効なユーザー' do
      let(:user_attributes) { attributes_for(:testuser, *@invalid_user_factory_params.sample) }
      it 'DBに登録されない' do
        expect do
          post signup_path, params: {
            user: user_attributes
          }
        end.to change { User.count }.by(0)
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
