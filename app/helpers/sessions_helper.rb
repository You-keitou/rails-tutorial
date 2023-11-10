module SessionsHelper
  # ユーザー検証
  def verificate_user!
    if current_user.nil? && remembered_user&.authenticated?(:remember,
                                                            cookies[:remember_token])
      log_in(remembered_user)
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
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def remembered_user
    User.find_by(id: cookies.signed[:user_id]) if cookies.signed[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
