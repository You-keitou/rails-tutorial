require 'rails_helper'

RSpec.describe 'support_helper test', type: :helper do

  describe 'invalid_email_maker' do
    let(:invalid_email) { invalid_email_maker }
    it '無効なアドレスが生成されているか' do
      expect(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match?(invalid_email)).to be(false)
    end
  end
end