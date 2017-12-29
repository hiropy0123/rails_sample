require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    # まずテストユーザーとしてログイン（ヘルパーはtest_helper.rbで定義）
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "", email: "foo@invalid", password: "foo", password_confirmation: "bar"} }
    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    # name と email を変数に格納
    name = "Foo Bar"
    email = "foo@bar.com"
    # パスワードが空でも更新できるようにする
    patch user_path(@user), params: { user: { name: name, email: email, password: "", password_confirmation: "" }}
    assert_not flash.empty?
    assert_redirected_to @user
    # @userをリロードしてでーたべーすから最新の情報を読み直す
    @user.reload
    # 変数に入れたnameと@user.nameがイコールになっていることを確認
    assert_equal name, @user.name
    # 変数に入れたemailと@user.emailがイコールになっていることを確認
    assert_equal email, @user.email
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    # name と email を変数に格納
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name, email: email}}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

end
