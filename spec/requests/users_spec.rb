require 'rails_helper'

RSpec.describe 'Users_controller', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe 'GET /signup' do
    it 'returns http success' do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'post /signup' do
    let(:base_user_attributes) do
      {
        name: 'keito',
        email: 'k.you@ingage.jp',
        password: '123456',
        password_confirmation: '123456'
      }
    end
    context '有効なユーザー' do
      it 'DBに登録されること' do
        expect do
          post signup_path, params: {
            user: base_user_attributes
          }
        end.to change { User.count }.by(1)
      end

      it 'ログイン状態になること' do
        post signup_path, params: {
          user: base_user_attributes
        }
        expect(logged_in?).to be(true)
      end
    end

    context '名前が無効なユーザー' do
      let(:invalid_user_attributes) do
        {
          name: 'a' * 51,
          **base_user_attributes.except(:name)
        }
      end
      it 'DBに登録されないこと' do
        expect do
          post signup_path, params: {
            user: invalid_user_attributes
          }
        end.to change { User.count }.by(0)
      end
    end

    context 'メールアドレスが無効なユーザー' do
      let(:invalid_user_attributes) do
        {
          email: '$$you@example.com',
          **base_user_attributes.except(:email)
        }
      end
      it 'DBに登録されないこと' do
        expect do
          post signup_path, params: {
            user: invalid_user_attributes
          }
        end.to change { User.count }.by(0)
      end
    end

    context 'パスワードが無効なユーザー' do
      let(:invalid_user_attributes) do
        {
          password: 'a' * 5,
          **base_user_attributes.except(:password)
        }
      end
      it 'DBに登録されないこと' do
        expect do
          post signup_path, params: {
            user: invalid_user_attributes
          }
        end.to change { User.count }.by(0)
      end
    end
  end

  describe 'get /users/[:id]/edit' do
    context '未ログインの時' do
      let(:user) {create(:testuser)}
      it 'Please log in というflashが表示されること' do
        get edit_user_path(user)
        expect(flash).to_not be_empty
      end

      it 'loginページにリダイレクトされること' do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end
    end

    context 'ログイン時' do
      let(:user) {create(:testuser)}
      let(:other_user) {create(:testuser)}
      it '正しいユーザーである時、正しく編集ページが表示されること' do
        log_in(user)
        get edit_user_path(user)
        expect(response.body).to include full_title('Edit user')
      end
      it '正しくユーザーであるときは、flashが表示されること' do
        log_in(user)
        get edit_user_path(other_user)
        expect(flash).to_not be_empty
      end
    end
  end

  describe 'title /signup' do
    it "title が #{full_title('Sign up')}となっていること" do
      get signup_path
      expect(response.body).to include("<title>#{full_title('Sign up')}</title>")
    end
  end
end

# なぜかここに宣言するとエラーになる？なんでなんでしょうかね？
#  def log_in(user)
#    post login_path, params: { session: { email: user.email,
#                                          password: user.password } }
#  end