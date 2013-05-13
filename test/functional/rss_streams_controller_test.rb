require 'test_helper'

class RssStreamsControllerTest < ActionController::TestCase
  setup do
    @rss_stream = rss_streams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rss_streams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rss_stream" do
    assert_difference('RssStream.count') do
      post :create, rss_stream: { title: @rss_stream.title, url: @rss_stream.url }
    end

    assert_redirected_to rss_stream_path(assigns(:rss_stream))
  end

  test "should show rss_stream" do
    get :show, id: @rss_stream
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rss_stream
    assert_response :success
  end

  test "should update rss_stream" do
    put :update, id: @rss_stream, rss_stream: { title: @rss_stream.title, url: @rss_stream.url }
    assert_redirected_to rss_stream_path(assigns(:rss_stream))
  end

  test "should destroy rss_stream" do
    assert_difference('RssStream.count', -1) do
      delete :destroy, id: @rss_stream
    end

    assert_redirected_to rss_streams_path
  end
end
