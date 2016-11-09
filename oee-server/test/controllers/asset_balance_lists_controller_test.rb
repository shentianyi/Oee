require 'test_helper'

class AssetBalanceListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @asset_balance_list = asset_balance_lists(:one)
  end

  test "should get index" do
    get asset_balance_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_asset_balance_list_url
    assert_response :success
  end

  test "should create asset_balance_list" do
    assert_difference('AssetBalanceList.count') do
      post asset_balance_lists_url, params: { asset_balance_list: { balance_date: @asset_balance_list.balance_date } }
    end

    assert_redirected_to asset_balance_list_url(AssetBalanceList.last)
  end

  test "should show asset_balance_list" do
    get asset_balance_list_url(@asset_balance_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_asset_balance_list_url(@asset_balance_list)
    assert_response :success
  end

  test "should update asset_balance_list" do
    patch asset_balance_list_url(@asset_balance_list), params: { asset_balance_list: { balance_date: @asset_balance_list.balance_date } }
    assert_redirected_to asset_balance_list_url(@asset_balance_list)
  end

  test "should destroy asset_balance_list" do
    assert_difference('AssetBalanceList.count', -1) do
      delete asset_balance_list_url(@asset_balance_list)
    end

    assert_redirected_to asset_balance_lists_url
  end
end
