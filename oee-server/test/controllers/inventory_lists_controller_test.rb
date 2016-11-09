require 'test_helper'

class InventoryListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inventory_list = inventory_lists(:one)
  end

  test "should get index" do
    get inventory_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_inventory_list_url
    assert_response :success
  end

  test "should create inventory_list" do
    assert_difference('InventoryList.count') do
      post inventory_lists_url, params: { inventory_list: { asset_balance_list_id: @inventory_list.asset_balance_list_id, inventory_date: @inventory_list.inventory_date, name: @inventory_list.name } }
    end

    assert_redirected_to inventory_list_url(InventoryList.last)
  end

  test "should show inventory_list" do
    get inventory_list_url(@inventory_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_inventory_list_url(@inventory_list)
    assert_response :success
  end

  test "should update inventory_list" do
    patch inventory_list_url(@inventory_list), params: { inventory_list: { asset_balance_list_id: @inventory_list.asset_balance_list_id, inventory_date: @inventory_list.inventory_date, name: @inventory_list.name } }
    assert_redirected_to inventory_list_url(@inventory_list)
  end

  test "should destroy inventory_list" do
    assert_difference('InventoryList.count', -1) do
      delete inventory_list_url(@inventory_list)
    end

    assert_redirected_to inventory_lists_url
  end
end
