# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  name            :string           not null
#  password_digest :string           not null
#  remember_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  #tutorialでは、accessorにしていたが、外部から書き込みができるようにするべきではないと思った。
  attr_reader :remember_token

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def remember_token_authenticated?(user, remember_token)
      return false if user.remember_digest.nil?
      BCrypt::Password.new(user.remember_digest).is_password?(remember_token)
    end
  end

  def remember!
    @remember_token = User.new_token
    #　updateにしたかったが、passwordのvalidationにどうしても引っかかる
    update_attribute(:remember_digest, User.digest(@remember_token))
  end

  def forget!
    update_attribute(:remember_digest, nil)
  end
end
