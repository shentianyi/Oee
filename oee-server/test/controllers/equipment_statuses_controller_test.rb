require 'test_helper'

class EquipmentStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equipment_status = equipment_statuses(:one)
  end

  test "should get index" do
    get equipment_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_equipment_status_url
    assert_response :success
  end

  test "should create equipment_status" do
    assert_difference('EquipmentStatus.count') do
      post equipment_statuses_url, params: { equipment_status: { desc: @equipment_status.desc, name: @equipment_status.name } }
    end

    assert_redirected_to equipment_status_url(EquipmentStatus.last)
  end

  test "should show equipment_status" do
    get equipment_status_url(@equipment_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_equipment_status_url(@equipment_status)
    assert_response :success
  end

  test "should update equipment_status" do
    patch equipment_status_url(@equipment_status), params: { equipment_status: { desc: @equipment_status.desc, name: @equipment_status.name } }
    assert_redirected_to equipment_status_url(@equipment_status)
  end

  test "should destroy equipment_status" do
    assert_difference('EquipmentStatus.count', -1) do
      delete equipment_status_url(@equipment_status)
    end

    assert_redirected_to equipment_statuses_url
  end
end
