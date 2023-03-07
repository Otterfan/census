require "application_system_test_case"

class Admin::NewsTest < ApplicationSystemTestCase
  setup do
    @admin_news = admin_news(:one)
  end

  test "visiting the index" do
    visit admin_news_url
    assert_selector "h1", text: "Admin/News"
  end

  test "creating a News" do
    visit admin_news_url
    click_on "New Admin/News"

    fill_in "Brief content", with: @admin_news.brief_content
    fill_in "Content", with: @admin_news.content
    fill_in "Note", with: @admin_news.note
    fill_in "Posted on", with: @admin_news.posted_on
    click_on "Create News"

    assert_text "News was successfully created"
    click_on "Back"
  end

  test "updating a News" do
    visit admin_news_url
    click_on "Edit", match: :first

    fill_in "Brief content", with: @admin_news.brief_content
    fill_in "Content", with: @admin_news.content
    fill_in "Note", with: @admin_news.note
    fill_in "Posted on", with: @admin_news.posted_on
    click_on "Update News"

    assert_text "News was successfully updated"
    click_on "Back"
  end

  test "destroying a News" do
    visit admin_news_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "News was successfully destroyed"
  end
end
