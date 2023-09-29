module LoginUserHelper
  def log_in_as(user_attributes, remember_me: false)
    visit login_path
    fill_in_form(user_attributes, login_form: true)
    check 'Remember me on this computer' if remember_me
    find('input[name="commit"]').click
  end
end
