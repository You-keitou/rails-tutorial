require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe "#create" do
    context "ログインしていない場合" do
      let (:user) { create(:testuser) }
      let (:other_user) { create(:testuser) }
      it "ログインページにリダイレクトすること" do
        expect do
          post relationships_path, params: { followed_id: other_user.id }
        end.to redirect_to login_path
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

      it "relationShipが作成されること" do
        log_in(user)
        expect do
          post relationships_path, params: { followed_id: other_user.id }
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
        expect do
          delete relationship_path(other_user.id)
        end.to redirect_to login_path
      end
    end

    context "ログインしている場合" do
      let(:user) { create(:testuser) }
      let(:other_user) { create(:testuser) }
      it "フォロー解除できること" do
        user.follow!(other_user)
        user.reload
        expect do
          delete relationship_path(other_user.id)
        end.to change{ user.following.count }.by(-1)
      end
    end
  end
end
