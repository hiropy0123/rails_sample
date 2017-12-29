require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

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

end
