module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # current_userの定義
  # インスタンス変数@current_userがすでに定義されていればそのまま、定義されていなければ、セッションからsession[:user_id]を代入
  def current_user
    @current_user ||= User.find_by( id: session[:user_id] )
  end


  # ユーザーがログインしていればtrue、ログインしていなければfalseを返す
  def logged_in?
    !current_user.nil?
  end

end
