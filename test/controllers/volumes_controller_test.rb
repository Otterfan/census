require 'test_helper'

class VolumesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @volume = volumes(:one)
  end

  test "should get index" do
    get volumes_url
    assert_response :success
  end

  test "should get new" do
    get new_volume_url
    assert_response :success
  end

  test "should create volume" do
    assert_difference('Volume.count') do
      post volumes_url, params: { volume: { author: @volume.author, date: @volume.date, location_id: @volume.location_id, title: @volume.title } }
    end

    assert_redirected_to volume_url(Volume.last)
  end

  test "should show volume" do
    get volume_url(@volume)
    assert_response :success
  end

  test "should get edit" do
    get edit_volume_url(@volume)
    assert_response :success
  end

  test "should update volume" do
    patch volume_url(@volume), params: { volume: { author: @volume.author, date: @volume.date, location_id: @volume.location_id, title: @volume.title } }
    assert_redirected_to volume_url(@volume)
  end

  test "should destroy volume" do
    assert_difference('Volume.count', -1) do
      delete volume_url(@volume)
    end

    assert_redirected_to volumes_url
  end
end
