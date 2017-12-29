class UsersController < ApplicationController
  # ログインユーザーに :edit と :update のコントロール権限を与える
  before_action :logged_in_user, only:[:edit, :update]
  # 正しいユーザーに :edit と :update のコントロール権限を与える
  before_action :correct_user, only:[:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # 更新に成功した場合
      flash[:success] = "プロフィールが更新されました"
      redirect_to @user

    else
      # 更新に失敗した場合
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
  # ここから下はprivateの領域 ------------------------------------

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認（他人のユーザー情報を操作させない）
    def correct_user
      @user = User.find(params[:id])
      # 正しいユーザー以外のURLにアクセスしたら、トップページにリダイレクト
      redirect_to root_url unless current_user?(@user)
    end


end
