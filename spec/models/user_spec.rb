# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  name            :string           not null
#  password_digest :string           not null
#  remember_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  # 有効なユーザーテスト
  describe '#user' do
    context '有効なユーザーの名前とメールアドレス' do
      let(:user_attributes) { attributes_for(:testuser) }
      it 'validであること' do
        expect(User.new(user_attributes).valid?).to be(true)
      end
    end
  end
  # 名前に関する検証
  describe '#name' do
    context '空白の時' do
      let(:user) { build(:testuser, name: '') }
      it 'validationエラーが出ること' do
        user.invalid?
        expect(user.errors[:name]).to be_present
      end
    end
    # 長さに関する検証
    context '長さが51の時' do
      let(:user) { build(:testuser, :username_length_variable, name_length: 51) }
      it 'validationエラーが出ること' do
        user.invalid?
        expect(user.errors[:name]).to be_present
      end
    end
    context '長さが50の時' do
      let(:user) { build(:testuser, :email_length_variable, name_length: 50) }
      it 'validであること' do
        expect(user.valid?).to be(true)
      end
    end
  end
  # emailに関する検証
  describe '#email' do
    # 存在性を検証
    context '空白の時' do
      let(:user) { build(:testuser, email: '') }
      it 'validationエラーが出ること' do
        user.invalid?
        expect(user.errors[:email]).to be_present
      end
    end
    # 長さを検証
    context '長さが255の有効な形式なメールアドレス' do
      let(:user) { build(:testuser, :email_length_variable, email_length: 255) }
      it 'validであること' do
        expect(user.valid?).to be(true)
      end
    end
    context '長さが256の有効な形式なメールアドレス' do
      let(:user) { build(:testuser, :email_length_variable, email_length: 256) }
      it 'validationエラーが出ること' do
        user.invalid?
        expect(user.errors[:email]).to be_present
      end
    end
    # フォーマットを検証
    context 'フォーマットに沿っていないもの' do
      let(:invalid_addresses) { (1..10).map { invalid_email_maker } }
      it 'validationエラーが出ること' do
        invalid_addresses.each do |address|
          user = build(:testuser, email: address)
          user.invalid?
          expect(user.errors[:email]).to be_present
        end
      end
    end
    # 一意性を検証
    context '既存のユーザーと重複する' do
      let(:dup_address) do
        if !User.exists?
          create(:testuser).email
        else
          User.all.sample[:email]
        end
      end
      it 'validationエラーが出ること' do
        # メールアドレスを大文字にする
        user = build(:testuser, email: dup_address.upcase)
        user.invalid?
        expect(user.errors[:email]).to be_present
      end
    end
  end

  describe 'password' do
    context '空であった場合' do
      it 'validationエラーが出ること' do
        user = build(:testuser, :non_password_user)
        user.invalid?
        expect(user.errors[:password]).to be_present
      end
    end

    context '長さが６の時' do
      let(:user) { build(:testuser, :password_length_variable, password_length: 6) }
      it 'validであること' do
        expect(user.valid?).to be(true)
      end
    end

    context '長さが5の時' do
      let(:user) { build(:testuser, :password_length_variable, password_length: 5) }
      it 'validationエラーが出ること' do
        expect(user.invalid?).to be(true)
      end
    end
  end

  describe 'remember_token_authenticated?の動作確認' do
    let(:user) { build(:testuser) }
    it 'remember_tokenがnilであるときはfalseを返すこと' do
      expect(user.remember_token).to be_nil
      expect(User::remember_token_authenticated?(user, ''))
    end
  end
end
