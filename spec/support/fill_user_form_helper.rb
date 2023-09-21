module FillUserFormHelper
  def fill_in_form(user_data, **form_kind)
    if !form_kind[:login_form].nil? || !form_kind[:signup_form].nil?
      fill_in 'user[name]', with: user_data[:name]
      fill_in 'user[password]', with: user_data[:password]
    end
    return if form_kind[:signup_form].nil?

    fill_in 'user[email]', with: user_data[:email]
    fill_in 'user[password_confirmation]', with: user_data[:password_confirmation]
  end
end
