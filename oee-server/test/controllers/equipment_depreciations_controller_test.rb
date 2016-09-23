require 'test_helper'

class EquipmentDepreciationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equipment_depreciation = equipment_depreciations(:one)
  end

  test "should get index" do
    get equipment_depreciations_url
    assert_response :success
  end

  test "should get new" do
    get new_equipment_depreciation_url
    assert_response :success
  end

  test "should create equipment_depreciation" do
    assert_difference('EquipmentDepreciation.count') do
      post equipment_depreciations_url, params: { equipment_depreciation: { depreciation_time: @equipment_depreciation.depreciation_time, depreciation_val: @equipment_depreciation.depreciation_val, equipment_track_id: @equipment_depreciation.equipment_track_id, net_val: @equipment_depreciation.net_val, original_val: @equipment_depreciation.original_val } }
    end

    assert_redirected_to equipment_depreciation_url(EquipmentDepreciation.last)
  end

  test "should show equipment_depreciation" do
    get equipment_depreciation_url(@equipment_depreciation)
    assert_response :success
  end

  test "should get edit" do
    get edit_equipment_depreciation_url(@equipment_depreciation)
    assert_response :success
  end

  test "should update equipment_depreciation" do
    patch equipment_depreciation_url(@equipment_depreciation), params: { equipment_depreciation: { depreciation_time: @equipment_depreciation.depreciation_time, depreciation_val: @equipment_depreciation.depreciation_val, equipment_track_id: @equipment_depreciation.equipment_track_id, net_val: @equipment_depreciation.net_val, original_val: @equipment_depreciation.original_val } }
    assert_redirected_to equipment_depreciation_url(@equipment_depreciation)
  end

  test "should destroy equipment_depreciation" do
    assert_difference('EquipmentDepreciation.count', -1) do
      delete equipment_depreciation_url(@equipment_depreciation)
    end

    assert_redirected_to equipment_depreciations_url
  end
end
