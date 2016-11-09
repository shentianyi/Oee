require 'test_helper'

class InventoryItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inventory_item = inventory_items(:one)
  end

  test "should get index" do
    get inventory_items_url
    assert_response :success
  end

  test "should get new" do
    get new_inventory_item_url
    assert_response :success
  end

  test "should create inventory_item" do
    assert_difference('InventoryItem.count') do
      post inventory_items_url, params: { inventory_item: { accum_dep: @inventory_item.accum_dep, acquis_val: @inventory_item.acquis_val, asset_description: @inventory_item.asset_description, book_val: @inventory_item.book_val, cap_date: @inventory_item.cap_date, fix_asset_track_id: @inventory_item.fix_asset_track_id, inventory_list_id: @inventory_item.inventory_list_id, profit_center: @inventory_item.profit_center, remark: @inventory_item.remark, status: @inventory_item.status, ts_area: @inventory_item.ts_area, ts_equipment_nr: @inventory_item.ts_equipment_nr, ts_equipment_type: @inventory_item.ts_equipment_type, ts_inventory_result: @inventory_item.ts_inventory_result, ts_inventory_user: @inventory_item.ts_inventory_user, ts_keeper: @inventory_item.ts_keeper, ts_nameplate_track: @inventory_item.ts_nameplate_track, ts_position: @inventory_item.ts_position, ts_project: @inventory_item.ts_project, ts_supplier: @inventory_item.ts_supplier, ts_type: @inventory_item.ts_type } }
    end

    assert_redirected_to inventory_item_url(InventoryItem.last)
  end

  test "should show inventory_item" do
    get inventory_item_url(@inventory_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_inventory_item_url(@inventory_item)
    assert_response :success
  end

  test "should update inventory_item" do
    patch inventory_item_url(@inventory_item), params: { inventory_item: { accum_dep: @inventory_item.accum_dep, acquis_val: @inventory_item.acquis_val, asset_description: @inventory_item.asset_description, book_val: @inventory_item.book_val, cap_date: @inventory_item.cap_date, fix_asset_track_id: @inventory_item.fix_asset_track_id, inventory_list_id: @inventory_item.inventory_list_id, profit_center: @inventory_item.profit_center, remark: @inventory_item.remark, status: @inventory_item.status, ts_area: @inventory_item.ts_area, ts_equipment_nr: @inventory_item.ts_equipment_nr, ts_equipment_type: @inventory_item.ts_equipment_type, ts_inventory_result: @inventory_item.ts_inventory_result, ts_inventory_user: @inventory_item.ts_inventory_user, ts_keeper: @inventory_item.ts_keeper, ts_nameplate_track: @inventory_item.ts_nameplate_track, ts_position: @inventory_item.ts_position, ts_project: @inventory_item.ts_project, ts_supplier: @inventory_item.ts_supplier, ts_type: @inventory_item.ts_type } }
    assert_redirected_to inventory_item_url(@inventory_item)
  end

  test "should destroy inventory_item" do
    assert_difference('InventoryItem.count', -1) do
      delete inventory_item_url(@inventory_item)
    end

    assert_redirected_to inventory_items_url
  end
end
