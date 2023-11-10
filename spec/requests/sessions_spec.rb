require 'rails_helper'

RSpec.describe 'Sessions_controller', type: :request do
  describe 'GET /login' do
    it 'returns http success' do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /login' do
    context '有効な値の場合' do
      let(:user_attributes) { attributes_for(:testuser) }
      it 'ログイン状態になること' do
        User.create(user_attributes)
        post login_path, params: {
          session: user_attributes.slice(:email, :password)
        }
        expect(logged_in?).to be(true)
      end
    end

    context '無効な値の場合' do
      let(:user_attributes) { attributes_for(:testuser) }
      it 'ログイン状態にならないこと' do
        post login_path, params: {
          session: user_attributes.slice(:email, :password)
        }
        expect(logged_in?).to be(false)
      end
    end
  end

  describe 'DELETE /login' do
    let(:user_attributes) { attributes_for(:testuser) }
    let(:user) { create(:testuser, user_attributes) }
    it 'ログイン状態からログアウト状態になること' do
      post login_path, params: {
        session: user_attributes.slice(:email, :password)
      }
      expect(logged_in?).to be(true)
      delete logout_path
      expect(current_user).to be_nil
    end
  end

  describe 'remember me' do
    let!(:user_attributes) { attributes_for(:testuser) }
    let!(:user) { create(:testuser, user_attributes) }
    it 'ONの場合はcookies[:remember_token]が空でないこと' do
      user_attributes[:remember_me] = '1'
      post login_path, params: {
        session: user_attributes.slice(:email, :password, :remember_me)
      }
      expect(cookies[:remember_token]).not_to be_blank
    end
    it 'OFFの場合はcookies[:remember_token]が空であること' do
      user_attributes[:remember_me] = '0'
      post login_path, params: {
        session: user_attributes.slice(:email, :password, :remember_me)
      }
      expect(cookies[:remember_token]).to be_blank
    end
  end
end
