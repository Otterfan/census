require 'test_helper'

class Public::ControlledNameControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_controlled_name_index_url
    assert_response :success
  end

  test "should get show" do
    get public_controlled_name_show_url
    assert_response :success
  end

end
