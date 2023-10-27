require 'rails_helper'

RSpec.describe 'AccountActivations', type: :request do
  describe 'Get edit_account_activation_url' do
    let(:user) { create(:testuser, :not_activated_user) }
    it 'サインアップしたユーザーが有効化されること' do
      expect(user.activated).to be false
      get edit_account_activation_url(user.activation_token, email: user.email)
      user.reload
      expect(user.activated).to be true
    end
    context 'すでに有効化されたユーザー' do
      let(:user) { create(:testuser) }
      it 'Your account is already activated.とflashが現れること' do
        get edit_account_activation_url(user.activation_token, email: user.email)
        expect(flash).to_not be_empty
        expect(flash['success']).to eq 'Your account is already activated.'
      end
      it 'userページにリダイレクトされること' do
        get edit_account_activation_url(user.activation_token, email: user.email)
        expect(response).to redirect_to user_path(user)
      end
    end
    context '有効でないトークンである時' do
      let(:user) { create(:testuser, :not_activated_user) }
      it '"Invalid activation link"というメッセージが出ること。' do
        get edit_account_activation_url('a', email: user.email)
        expect(flash).to_not be_empty
        expect(flash['danger']).to eq 'Invalid activation link'
      end
      it 'ホーム画面にリダイレクトされること' do
        get edit_account_activation_url('a', email: user.email)
        expect(response).to redirect_to root_path
      end
    end
  end
end
