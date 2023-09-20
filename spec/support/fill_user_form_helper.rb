module FillUserFormHelper
  def fill_in_form(user_data)
    fill_in 'user[name]', with: user_data[:name]
    fill_in 'user[email]', with: user_data[:email]
    fill_in 'user[password]', with: user_data[:password]
    fill_in 'user[password_confirmation]', with: user_data[:password_confirmation]
  end
end
