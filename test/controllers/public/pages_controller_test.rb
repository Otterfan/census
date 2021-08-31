require 'test_helper'

class Public::PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get privacy" do
    get public_pages_privacy_url
    assert_response :success
  end

end
