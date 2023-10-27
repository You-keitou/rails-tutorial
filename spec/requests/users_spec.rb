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

    it 'メールが一件存在すること' do
      expect do
        post signup_path, params: {
          user: base_user_attributes
        }
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'ユーザーがデフォルトでは有効化されていないこと' do
      post signup_path, params: {
        user: base_user_attributes
      }
      expect(User.find_by(email: base_user_attributes[:email]).activated).to be false
    end
  end

  describe 'get /users/[:id]/edit' do
    context '未ログインの時' do
      let(:user) { create(:testuser) }
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
      let(:user) { create(:testuser) }
      let(:other_user) { create(:testuser) }
      it '正しいユーザーである時、正しく編集ページが表示されること' do
        log_in(user)
        get edit_user_path(user)
        expect(response.body).to include full_title('Edit user')
      end
      it '他のユーザーのプロフィールを編集しようとするときは、flashが表示されること' do
        log_in(user)
        get edit_user_path(other_user)
        expect(flash).to_not be_empty
      end
    end
  end

  describe 'patch /users/[:id]' do
    context '未ログインの時' do
      let(:user) { create(:testuser) }
      it 'Please log in というflashが表示されること' do
        patch user_path(user), params: { user: { name: 'keito',
                                                 email: 'aaa@example.com'  } }
        expect(flash).to_not be_empty
      end
    end
    context 'ログイン時' do
      let(:user) { create(:testuser) }
      it '正しいユーザーである時、正しく編集されること' do
        log_in(user)
        patch user_path(user), params: { user: { name: 'keito',
                                                 email: 'you@example.com'  } }
        expect(user.reload.name).to eq 'keito'
        expect(user.reload.email).to eq 'you@example.com'
      end

      it 'admin属性は更新できないこと' do
        log_in(user)
        expect(user.admin).to be false
        old_email = user.email
        patch user_path(user), params: {
          user: {
            email: "#{old_email}.jp",
            password: 'password',
            password_confirmation: 'password',
            admin: true
          }
        }
        user.reload
        expect(user.email).to eq "#{old_email}.jp"
        expect(user.admin).to be false
      end
    end
  end

  describe 'get /users' do
    context '未ログインの時' do
      let(:user) { create(:testuser) }
      it 'Please log in というflashが表示されること' do
        get users_path
        expect(flash).to_not be_empty
      end
    end
    context 'ログイン時' do
      let(:user) { create(:testuser) }
      it '正しく表示されること' do
        log_in(user)
        get users_path
        expect(response.body).to include full_title('All users')
      end
    end
    it 'activateされていないユーザーは表示されないこと' do
      not_activated_user = create(:testuser, :not_activated_user)
      user = create(:testuser)
      log_in(user)
      get users_path
      expect(response.body).to include user.name
      expect(response.body).to_not include not_activated_user.name
    end
  end

  describe 'get /user/[:id]' do
    let(:not_activated_user) { create(:testuser, :not_activated_user) }
    let(:user) { create(:testuser) }
    it '有効化されていないユーザーはrootにリダイレクトされること' do
      log_in(user)
      get user_path(not_activated_user)
      expect(response).to redirect_to root_path
    end
  end

  describe 'delete /user/[:id]' do
    let!(:admin) { create(:testuser, :admin_user) }
    let!(:user) { create(:testuser) }
    let!(:testuser) { create(:testuser) }
    # びっくりをつけないと、以下のテストが通らない
    context '管理者である時' do
      it '削除ができる' do
        log_in(admin)
        expect do
          delete user_path(testuser)
        end.to change { User.count }.by(-1)
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
