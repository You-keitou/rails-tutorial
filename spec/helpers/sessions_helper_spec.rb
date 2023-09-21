require 'rails_helper'

RSpec.describe 'session_helper' ,type: :helper  do
	let!(:user) {create(:testuser)}
	context 'log_in' do
		it 'sessionにuser.idが正しく代入されること' do
			log_in(user)
			expect(session[:user_id]).to eq user.id
		end
	end

	context 'current_user' do
		it '現在ログインしているユーザーのインスタンス変数が正しくあること' do
			log_in(user)
			expect(current_user).to eq user
		end
	end

	context 'logged_in?' do
		it 'ログインしていないときはfalseを返すこと' do
			expect(logged_in?).to be(false)
		end
		it 'ログインしているときはtrueを返すこと' do
			log_in(user)
			expect(logged_in?).to be(true)
		end
	end

	context 'log_out' do
		it 'ログインしている状態からログインしていない状態にすること' do
			#まず、ログインをしてみる
			log_in(user)
			expect(current_user).to eq(user)
			log_out
			expect(current_user).to be_nil
		end
	end
end