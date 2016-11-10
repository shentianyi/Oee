require 'test_helper'

class UserInventoryTasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_inventory_task = user_inventory_tasks(:one)
  end

  test "should get index" do
    get user_inventory_tasks_url
    assert_response :success
  end

  test "should get new" do
    get new_user_inventory_task_url
    assert_response :success
  end

  test "should create user_inventory_task" do
    assert_difference('UserInventoryTask.count') do
      post user_inventory_tasks_url, params: { user_inventory_task: { end_time: @user_inventory_task.end_time, inventory_list_id: @user_inventory_task.inventory_list_id, real_qty: @user_inventory_task.real_qty, start_time: @user_inventory_task.start_time, target_qty: @user_inventory_task.target_qty, type: @user_inventory_task.type, user_id: @user_inventory_task.user_id } }
    end

    assert_redirected_to user_inventory_task_url(UserInventoryTask.last)
  end

  test "should show user_inventory_task" do
    get user_inventory_task_url(@user_inventory_task)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_inventory_task_url(@user_inventory_task)
    assert_response :success
  end

  test "should update user_inventory_task" do
    patch user_inventory_task_url(@user_inventory_task), params: { user_inventory_task: { end_time: @user_inventory_task.end_time, inventory_list_id: @user_inventory_task.inventory_list_id, real_qty: @user_inventory_task.real_qty, start_time: @user_inventory_task.start_time, target_qty: @user_inventory_task.target_qty, type: @user_inventory_task.type, user_id: @user_inventory_task.user_id } }
    assert_redirected_to user_inventory_task_url(@user_inventory_task)
  end

  test "should destroy user_inventory_task" do
    assert_difference('UserInventoryTask.count', -1) do
      delete user_inventory_task_url(@user_inventory_task)
    end

    assert_redirected_to user_inventory_tasks_url
  end
end
