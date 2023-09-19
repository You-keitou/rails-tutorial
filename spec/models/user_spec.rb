# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  name            :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  #有効なユーザーテスト
  describe '#user' do
    context '有効なユーザーの名前とメールアドレス' do
      let(:user) { build(:testuser) }
      it 'validであること' do
        expect(user.valid?).to be(true)
      end
    end
  end
  #名前に関する検証
  describe '#name' do
    context '空白の時' do
      let(:user) { build(:testuser, name: "") }
      it 'validでないこと' do
        user.invalid?
        expect(user.errors[:name]).to be_present
      end
    end
    #長さに関する検証
    context '長さが51の時' do
      let(:user) { build(:testuser, :username_length_variable, name_length: 51) }
      it 'validでないこと' do
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
  #emailに関する検証
  describe '#email' do
    #存在性を検証
    context '空白の時' do
      let(:user) { build(:testuser, email: '') }
      it 'validでないこと' do
        user.invalid?
        expect(user.errors[:email]).to be_present
      end
    end
    #長さを検証
    context '長さが255の有効な形式なメールアドレス' do
      let(:user) { build(:testuser, :email_length_variable, email_length: 255) }
      it 'validであること' do
        expect(user.valid?).to be(true)
      end
    end
    context '長さが256の有効な形式なメールアドレス' do
      let(:user) { build(:testuser, :email_length_variable, email_length: 256) }
      it 'validでないこと' do
        user.invalid?
        expect(user.errors[:email]).to be_present
      end
    end
    # フォーマットを検証
    context 'フォーマットに沿っていないもの' do
      let(:invalid_addresses) { (1..10).map { invalid_email_maker } }
      it 'validでないこと' do
        invalid_addresses.each do |adress|
          user = build(:testuser, email: adress)
          user.invalid?
          expect(user.errors[:email]).to be_present
        end
      end
    end
    # 一意性を検証
    context '既存のユーザーと重複する' do
      let(:dup_adress) {
        if User.limit(1).empty?
          create(:testuser).email
        else
          User.limit(100).pluck(:email).sample
        end
      }
      it 'validでないこと' do
        # メールアドレスを大文字にする
        user = build(:testuser, email: dup_adress.upcase)
        user.invalid?
        expect(user.errors[:email]).to be_present
      end
    end
  end
end
