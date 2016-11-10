require 'test_helper'

class UserAreaItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_area_item = user_area_items(:one)
  end

  test "should get index" do
    get user_area_items_url
    assert_response :success
  end

  test "should get new" do
    get new_user_area_item_url
    assert_response :success
  end

  test "should create user_area_item" do
    assert_difference('UserAreaItem.count') do
      post user_area_items_url, params: { user_area_item: { area_id: @user_area_item.area_id, user_id: @user_area_item.user_id } }
    end

    assert_redirected_to user_area_item_url(UserAreaItem.last)
  end

  test "should show user_area_item" do
    get user_area_item_url(@user_area_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_area_item_url(@user_area_item)
    assert_response :success
  end

  test "should update user_area_item" do
    patch user_area_item_url(@user_area_item), params: { user_area_item: { area_id: @user_area_item.area_id, user_id: @user_area_item.user_id } }
    assert_redirected_to user_area_item_url(@user_area_item)
  end

  test "should destroy user_area_item" do
    assert_difference('UserAreaItem.count', -1) do
      delete user_area_item_url(@user_area_item)
    end

    assert_redirected_to user_area_items_url
  end
end
