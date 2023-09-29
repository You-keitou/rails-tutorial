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
    let(:user_attributes) { {
        name: 'keito',
        email: 'k.you@ingage.jp',
        password: '123456',
        password_confirmation: '123456'
    } }
    context '有効なユーザー' do
      it 'DBに登録されること' do
        expect do
          post signup_path, params: {
            user: user_attributes
          }
        end.to change { User.count }.by(1)
      end
    end

    context '名前が無効なユーザー' do
      let(:invalid_user_attributes) { {
        name: 'a' * 51,
        user_attributes.except(:name)
      }}
      it 'DBに登録されないこと' do
        expect do
          post signup_path, params: {
            user: user_attributes
          }
        end.to change { User.count }.by(0)
      end
    end

    context 'メールアドレスが無効なユーザー' do
      let(:invalid_user_attributes) { {
        email: 'a' * 244 + '@example.com',
        user_attributes.except(:email)
      }}
      it 'DBに登録されないこと' do
        expect do
          post signup_path, params: {
            user: user_attributes
          }
        end .to change { User.count }.by(0)
      end
    end

    context 'パスワードが無効なユーザー' do
      let(:invalid_user_attributes) { {
        password: 'a' * 5,
        user_attributes.except(:password)
      }}
      it 'DBに登録されないこと' do
        expect do
          post signup_path, params: {
            user: user_attributes
          }
        end .to change { User.count }.by(0)
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
