require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe "#create" do
    context "ログインしていない場合" do
      let (:user) { create(:testuser) }
      let (:other_user) { create(:testuser) }
      it "ログインページにリダイレクトすること" do
      post relationships_path, params: { followed_id: other_user.id }
      expect(response).to redirect_to login_path
      end

      it "フォローできないこと" do
        expect do
          post relationships_path, params: { followed_id: other_user.id }
        end.to change { Relationship.count }.by(0)
      end

    end

    context "ログインしている場合" do
      let (:user) { create(:testuser) }
      let (:other_user) { create(:testuser) }

      it "フォローできること" do
        log_in(user)
        post relationships_path, params: { followed_id: other_user.id }
        expect(user.following?(other_user)).to be true
      end

      it "relationShipレコードが作成されること" do
        log_in(user)
        expect do
          post relationships_path, params: { followed_id: other_user.id }
        end.to change{ Relationship.count }.by(1)
      end

      it "Ajaxでも登録できること" do
        log_in(user)
        expect do
          post relationships_path, params: { followed_id: other_user.id }, xhr: true
        end.to change{ Relationship.count }.by(1)
      end
    end
  end

  describe "#destroy" do
    context "ログインしていない場合" do
      let(:user) { create(:testuser) }
      let(:other_user) { create(:testuser) }
      it "ログインページにリダイレクトすること" do
        user.follow!(other_user)
        delete relationship_path(user.active_relationships.find_by(followed_id: other_user).id)
        expect(response).to redirect_to login_path
      end
    end

    context "ログインしている場合" do
      let(:user) { create(:testuser) }
      let(:other_user) { create(:testuser) }
      it "フォロー解除できること" do
        log_in(user)
        user.follow!(other_user)
        expect do
            delete relationship_path(user.active_relationships.find_by(followed_id: other_user).id)
        end.to change{ user.following.count }.by(-1)
        expect(user.following.include?(other_user)).to be false
      end

      it "Ajaxでも解除できること" do
        log_in(user)
        user.follow!(other_user)
        expect do
          delete relationship_path(user.active_relationships.find_by(followed_id: other_user).id), xhr: true
        end.to change(Relationship, :count).by(-1)
      end
    end
  end
end
