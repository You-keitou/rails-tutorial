require 'rails_helper'

RSpec.describe "Microposts", type: :request do

  let(:user) { create(:testuser) }

  describe 'create action' do
    it 'should redirect create when not logged in' do
      post microposts_path, params: {micropost: {content: "Lorem ipsum"}}
      expect(response).to redirect_to login_url
    end
  end

  describe 'destroy action' do
    it 'should redirect destroy when not logged in' do
      micropost = send(:create_testpost, user: user, posts_count: 1).first
      delete micropost_path(micropost)
      expect(response).to redirect_to login_url
    end
  end
end
