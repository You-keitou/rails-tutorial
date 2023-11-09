require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) {create(:testuser)}

  describe '#new' do
    it 'password_reset[email]という属性のinputタグが表示されること' do
      get new_password_reset_url
      expect(response.body).to include 'name="password_reset[email]"'
    end
  end

  describe '#create' do
    context 'メールアドレスがDBに保存されていない時' do
      it 'flashが表示されること' do
        dummy_email = Faker::Internet.email
        expect(User.find_by(email: dummy_email)).to be nil
        post password_resets_path, params: {
          password_reset: {email: dummy_email}
        }
        expect(flash).not_to be_empty
        expect(response.body).to include 'Email adress not found'
      end

      it 'newが再びレンダーされること' do
        dummy_email = Faker::Internet.email
        expect(User.find_by(email: dummy_email)).to be nil
        post password_resets_path, params: {
          password_reset: {email: dummy_email}
        }
        expect(response).to have_http_status(:success)
        expect(response.body).to include 'Forgot password'
      end
    end
    context '有効なメールアドレスである場合' do
      it 'info flashが表示されること' do
        post password_resets_path, params: {
          password_reset: {email: user.email}
        }
        expect(flash).not_to be_empty
        expect(flash[:info]).to match 'Email sent with password reset instructions'
      end

      it 'rootにリダイレクトされること' do
        post password_resets_path, params: {
          password_reset: {email: user.email}
        }
        expect(response).to redirect_to root_url
      end

      it '送信メールが一件増えること' do
        expect do
          post password_resets_path, params: {
            password_reset: {email: user.email}
          }
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
      end
    end
  end

  describe '#edit' do
    context 'パスワードリセットトークンが期限切れである時' do
      it 'flashが表示されること' do
        user.create_reset_digest
        user.update(reset_sent_at: Time.zone.now - 3.hours)
        expect(user.password_reset_expired?).to be true
        get edit_password_reset_path(id: user.reset_token, email: user.email)
        expect(flash[:danger]).to match 'password reset has expired.'
      end
      it '#newにリダイレクトされること' do
        user.create_reset_digest
        user.update(reset_sent_at: Time.zone.now - 3.hours)
        expect(user.password_reset_expired?).to be true
        get edit_password_reset_path(id: user.reset_token, email: user.email)
        expect(response).to redirect_to new_password_reset_path
      end
    end
    context 'ユーザーがまだ有効化されていない時' do
      let(:not_activated_user){create(:testuser, :not_activated_user)}
      it 'rootにリダイレクトされること' do
        not_activated_user.create_reset_digest
        not_activated_user.update(reset_sent_at: Time.zone.now)
        get edit_password_reset_path(id: not_activated_user.reset_token, email: not_activated_user.email)
        expect(response).to redirect_to root_url
      end
    end
  end

end
