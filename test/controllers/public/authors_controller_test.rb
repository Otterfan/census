require 'test_helper'

class Public::AuthorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_authors_index_url
    assert_response :success
  end

  test "should get show" do
    get public_authors_show_url
    assert_response :success
  end

end
