module SessionsHelper
  #ユーザー検証
  def authenticate_user!
    if current_user.nil?
      if remembered_user && User.remember_token_authenticated?(remembered_user ,cookies[:remember_token])
        log_in(remembered_user)
      end
    end
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    return if current_user.nil?
    forget(current_user)
    session.delete(:user_id)
  end

  def remember(user)
    user.remember!
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget!
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user
    # ユーザーが見つからなかった時の処理はどうするか？
    return User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def remembered_user
    return User.find_by(id: cookies.signed[:user_id]) if user_id = cookies.signed[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

end
