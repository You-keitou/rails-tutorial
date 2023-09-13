require 'rails_helper'

# 引数ありの場合、　引数なしの場合
RSpec.describe 'full_title_helper', type: :helper do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe 'full_title one argument' do
    it 'full_titleヘルパーに引数が与えられた時に、きちんと表示すること' do
      argument = 'About us'
      expect(full_title('About us')).to eq "#{argument} | #{base_title}"
    end
  end

  describe 'full_title no argument' do
    it 'full_titleヘルパーに引数が与えられない時に、base_titleのみかえること' do
      expect(full_title).to eq base_title
    end
  end
end
