# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  name            :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :testuser, class: User do
    name {Faker::Name.last_name}
    email {Faker::Internet.free_email}

    transient do
      name_length {50}
      email_length {255}
    end

    trait :email_invalid_character do
      email { invalid_email_maker }
    end

    trait :email_length_variable do
      domain = Faker::Internet.domain_name(subdomain: true)
      email {random_alphbet_sequence(email_length - domain.length - 1) + '@' + domain}
    end

    trait :username_length_variable do
      name {random_alphbet_sequence(name_length)}
    end
  end
end

def invalid_email_maker
  invalid_character = "! @ # $ % ^ & * ( ) = { } ¥ \' \" ' '"
  email = Faker::Internet.free_email
  # ローカル部分とドメインに無効文字を挿入するかどうか
  insert_invalid_character_flag = [[true, true],[true, false],[false, true]]
  email.split('@')
    .zip(insert_invalid_character_flag.sample)
    .map{ |each_part, flag| flag ? each_part.insert(each_part.length - 1, invalid_character.chars.sample) : each_part }
    .join('@')
end

def random_alphbet_sequence(len)
  Array.new(len){rand(26)}.map{|n| ('a'..'z').to_a[n] }.join()
end
