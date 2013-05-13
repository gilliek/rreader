require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  test "should get import_export" do
    get :import_export
    assert_response :success
  end

  test "should get do_import" do
    get :do_import
    assert_response :success
  end

  test "should get do_export" do
    get :do_export
    assert_response :success
  end

end
