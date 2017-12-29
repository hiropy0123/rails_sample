require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should redirect index when not logged in" do
    # ユーザーの一覧ページ
    get users_path
    # ログインページにリダイレクト
    assert_redirected_to login_url
  end

  #  admin属性の変更が禁止されていることをテストする
  # test "should not allow the admin attribute to be edited via the web" do
  #   log_in_as(@other_user)
  #   assert_not @other_user.admin?
  #   patch user_path(@other_user), params: {
  #                                   user: { password:              "password",
  #                                           password_confirmation: "password",
  #                                           admin: '1' } }
  #   assert_not @other_user.reload.admin?
  # end

  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", "サインイン | My Rails Sample App"
  end

  # ユーザーが自分以外の情報を編集できないようになっているか確認するテスト
  test "should redirect edit when in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email}}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

end
