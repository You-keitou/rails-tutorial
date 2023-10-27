require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'account_activation' do
    let(:user) { create(:testuser) }
    let(:mail) { UserMailer.account_activation(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Account activation')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it 'メール本文にユーザー名が含まれていること' do
      expect(mail.body.encoded).to match(user.name)
    end

    it 'メール本文に有効化トークンが含まれていること' do
      expect(mail.body.encoded).to match(user.activation_token)
    end

    it 'メール本文にエスケープされたメールアドレスが含まれていること' do
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end

  describe 'password_reset' do
    let(:user) { create(:testuser) }
    let(:mail) { UserMailer.password_reset(user) }

    it 'renders the headers' do
      user.create_reset_digest
      expect(mail.subject).to eq('Password reset')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it 'メール本文にreset_tokenが含まれていること' do
      user.create_reset_digest
      expect(mail.body.encoded).to match(user.reset_token)
    end

    it 'メール本文にユーザーのemailが表示されていること' do
      user.create_reset_digest
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end
end
