require 'test_helper'

class AssetBalanceItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @asset_balance_item = asset_balance_items(:one)
  end

  test "should get index" do
    get asset_balance_items_url
    assert_response :success
  end

  test "should get new" do
    get new_asset_balance_item_url
    assert_response :success
  end

  test "should create asset_balance_item" do
    assert_difference('AssetBalanceItem.count') do
      post asset_balance_items_url, params: { asset_balance_item: { accum_dep: @asset_balance_item.accum_dep, acquis_val: @asset_balance_item.acquis_val, asset_class: @asset_balance_item.asset_class, asset_description: @asset_balance_item.asset_description, book_val: @asset_balance_item.book_val, cap_date: @asset_balance_item.cap_date, fix_asset_track_id: @asset_balance_item.fix_asset_track_id, inventory_nr: @asset_balance_item.inventory_nr, profit_center: @asset_balance_item.profit_center, remark: @asset_balance_item.remark, status: @asset_balance_item.status, ts_area: @asset_balance_item.ts_area, ts_equipment_nr: @asset_balance_item.ts_equipment_nr, ts_equipment_type: @asset_balance_item.ts_equipment_type, ts_inventory_result: @asset_balance_item.ts_inventory_result, ts_inventory_user: @asset_balance_item.ts_inventory_user, ts_keeper: @asset_balance_item.ts_keeper, ts_nameplate_track: @asset_balance_item.ts_nameplate_track, ts_position: @asset_balance_item.ts_position, ts_project: @asset_balance_item.ts_project, ts_supplier: @asset_balance_item.ts_supplier, ts_type: @asset_balance_item.ts_type } }
    end

    assert_redirected_to asset_balance_item_url(AssetBalanceItem.last)
  end

  test "should show asset_balance_item" do
    get asset_balance_item_url(@asset_balance_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_asset_balance_item_url(@asset_balance_item)
    assert_response :success
  end

  test "should update asset_balance_item" do
    patch asset_balance_item_url(@asset_balance_item), params: { asset_balance_item: { accum_dep: @asset_balance_item.accum_dep, acquis_val: @asset_balance_item.acquis_val, asset_class: @asset_balance_item.asset_class, asset_description: @asset_balance_item.asset_description, book_val: @asset_balance_item.book_val, cap_date: @asset_balance_item.cap_date, fix_asset_track_id: @asset_balance_item.fix_asset_track_id, inventory_nr: @asset_balance_item.inventory_nr, profit_center: @asset_balance_item.profit_center, remark: @asset_balance_item.remark, status: @asset_balance_item.status, ts_area: @asset_balance_item.ts_area, ts_equipment_nr: @asset_balance_item.ts_equipment_nr, ts_equipment_type: @asset_balance_item.ts_equipment_type, ts_inventory_result: @asset_balance_item.ts_inventory_result, ts_inventory_user: @asset_balance_item.ts_inventory_user, ts_keeper: @asset_balance_item.ts_keeper, ts_nameplate_track: @asset_balance_item.ts_nameplate_track, ts_position: @asset_balance_item.ts_position, ts_project: @asset_balance_item.ts_project, ts_supplier: @asset_balance_item.ts_supplier, ts_type: @asset_balance_item.ts_type } }
    assert_redirected_to asset_balance_item_url(@asset_balance_item)
  end

  test "should destroy asset_balance_item" do
    assert_difference('AssetBalanceItem.count', -1) do
      delete asset_balance_item_url(@asset_balance_item)
    end

    assert_redirected_to asset_balance_items_url
  end
end
