class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: paramas[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      # redirect_to 
    else
      # エラーメッセージを作成する
      render 'new'
    end
  end

  def destroy
  end

end
