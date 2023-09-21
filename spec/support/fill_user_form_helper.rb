module FillUserFormHelper
  def fill_in_form(user_data, **form_kind)
    controller_name = !form_kind[:login_form].nil? ? 'session' : 'user'

    if form_kind[:login_form] || form_kind[:signup_form]
      fill_in "#{controller_name}[email]", with: user_data[:email]
      fill_in "#{controller_name}[password]", with: user_data[:password]
    end
    return if form_kind[:login_form]

    fill_in "#{controller_name}[name]", with: user_data[:name]
    fill_in "#{controller_name}[password_confirmation]", with: user_data[:password_confirmation]
  end
end
