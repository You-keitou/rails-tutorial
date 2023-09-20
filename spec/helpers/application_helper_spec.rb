require 'rails_helper'

# 引数ありの場合、　引数なしの場合
RSpec.describe 'full_title_helper', type: :helper do
  describe 'full_title' do
    let(:base_title) { 'Ruby on Rails Tutorial Sample App' }
    context '引数あり' do
      it '引数とベースタイトルが合わせて表示されること' do
        argument = 'About us'
        expect(full_title('About us')).to eq "#{argument} | #{base_title}"
      end
    end
    context '引数なし' do
      it 'ベースタイトルのみ表示されること' do
        expect(full_title).to eq base_title
      end
    end
  end

  describe 'invalid_email_maker' do
    let(:invalid_email) { invalid_email_maker }
    it '無効なアドレスが生成されているか' do
      expect(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match?(invalid_email)).to be(false)
    end
  end
end
