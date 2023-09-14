# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  #有効なユーザーテスト
  describe '#user' do
    context '有効なユーザーの名前とメールアドレス' do
      let(:user) {User.new(name: 'you', email: 'you@gmail.com')}
      it 'validであること' do
        expect(user.valid?).to be(true)
      end
    end
  end
  #名前に関する検証
  describe '#name' do
    context '空白の時' do
      let(:user) {User.new(name: '')}
      it 'validでないこと' do
        user.invalid?
        expect(user.errors[:name]).to be_present
      end
    end
    #長さに関する検証
    context '長さが51の時' do
      let(:user) {User.new(name: random_alphbet_sequence(51))}
      it 'validでないこと' do
        user.invalid?
        expect(user.errors[:name]).to be_present
      end
    end
    context '長さが50の時' do
      let(:user) {User.new(name: random_alphbet_sequence(50))}
      it 'validであること' do
        expect(user.valid?).to be(true)
      end
    end
  end
  #emailに関する検証
  describe '#email' do
    #存在性を検証
    context '空白の時' do
      let(:user) {User.new(email: '')}
      it 'validでないこと' do
        user.invalid?
        expect(user.errors[:email]).to be_present
      end
    end
    #長さを検証
    context '長さが255の有効な形式なメールアドレス' do
      let(:user) {User.new(email: random_alphbet_sequence(243) + '@example.com')}
      it 'validであること' do
        expect(user.valid?).to be(true)
      end
    end
    context '長さが256の有効な形式なメールアドレス' do
      let(:user) {User.new(email: random_alphbet_sequence(244) + '@example.com')}
      it 'validでないこと' do
        user.invalid?
        expect(user.errors[:email]).to be_present
      end
    end
    # フォーマットを検証
    context 'フォーマットに沿っていないもの' do
      let(:invalid_addresses) {%w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]}
      it 'validでないこと' do
        invalid_addresses.each do |adress|
          user = User.new(email: adress)
          user.invalid?
          expect(user.errors[:email]).to be_present
        end
      end
    end
  end
end
