require 'test_helper'

class FeedEntriesActionsControllerTest < ActionController::TestCase
  test "should get star_item" do
    get :star_item
    assert_response :success
  end

  test "should get mark_as_read" do
    get :mark_as_read
    assert_response :success
  end

  test "should get mark_as_unread" do
    get :mark_as_unread
    assert_response :success
  end

  test "should get remove_item" do
    get :remove_item
    assert_response :success
  end

end
