require 'test_helper'

class Admin::NewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_news = admin_news(:one)
  end

  test "should get index" do
    get admin_news_index_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_news_url
    assert_response :success
  end

  test "should create admin_news" do
    assert_difference('Admin::News.count') do
      post admin_news_index_url, params: { admin_news: { brief_content: @admin_news.brief_content, content: @admin_news.content, note: @admin_news.note, posted_on: @admin_news.posted_on } }
    end

    assert_redirected_to admin_news_url(Admin::News.last)
  end

  test "should show admin_news" do
    get admin_news_url(@admin_news)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_news_url(@admin_news)
    assert_response :success
  end

  test "should update admin_news" do
    patch admin_news_url(@admin_news), params: { admin_news: { brief_content: @admin_news.brief_content, content: @admin_news.content, note: @admin_news.note, posted_on: @admin_news.posted_on } }
    assert_redirected_to admin_news_url(@admin_news)
  end

  test "should destroy admin_news" do
    assert_difference('Admin::News.count', -1) do
      delete admin_news_url(@admin_news)
    end

    assert_redirected_to admin_news_index_url
  end
end
