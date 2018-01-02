require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない userは複数のmicropostを持つことができる
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should valid" do
    assert @micropost.valid?
  end

  test "user id shoule be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content shoud present" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most resent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
