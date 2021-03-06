class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "アカウント有効化するために、メールをご確認ください"
      redirect_to root_url
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

  def index
    # @users = User.all
    @users = User.paginate(page: params[:page])
  end

  def show
    if User.find_by(id: params[:id])
      @user = User.find(params[:id])
      @microposts = @user.microposts.paginate(page: params[:page])
    else
      # user idが実在しない場合はトップにリダイレクト
      redirect_to root_url
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  private
  # ここから下はprivateの領域 ------------------------------------

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # 正しいユーザーかどうか確認（他人のユーザー情報を操作させない）
    def correct_user
      @user = User.find(params[:id])
      # 正しいユーザー以外のURLにアクセスしたら、トップページにリダイレクト
      redirect_to root_url unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to root_url unless current_user.admin?
    end


end
