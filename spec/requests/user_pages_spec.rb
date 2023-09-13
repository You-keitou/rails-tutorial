require 'rails_helper'

RSpec.describe 'Userページのテスト', type: :request do
	describe 'Get user/new' do
		it 'return http request success' do
			get users_new_path
			expect(response).to have_http_status(:success)
		end
	end
end