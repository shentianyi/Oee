require 'test_helper'

class EquipmentReleasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equipment_release = equipment_releases(:one)
  end

  test "should get index" do
    get equipment_releases_url
    assert_response :success
  end

  test "should get new" do
    get new_equipment_release_url
    assert_response :success
  end

  test "should create equipment_release" do
    assert_difference('EquipmentRelease.count') do
      post equipment_releases_url, params: { equipment_release: { equipment_track_id: @equipment_release.equipment_track_id, release_index: @equipment_release.release_index, release_time: @equipment_release.release_time } }
    end

    assert_redirected_to equipment_release_url(EquipmentRelease.last)
  end

  test "should show equipment_release" do
    get equipment_release_url(@equipment_release)
    assert_response :success
  end

  test "should get edit" do
    get edit_equipment_release_url(@equipment_release)
    assert_response :success
  end

  test "should update equipment_release" do
    patch equipment_release_url(@equipment_release), params: { equipment_release: { equipment_track_id: @equipment_release.equipment_track_id, release_index: @equipment_release.release_index, release_time: @equipment_release.release_time } }
    assert_redirected_to equipment_release_url(@equipment_release)
  end

  test "should destroy equipment_release" do
    assert_difference('EquipmentRelease.count', -1) do
      delete equipment_release_url(@equipment_release)
    end

    assert_redirected_to equipment_releases_url
  end
end
