require 'test_helper'

class PamListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pam_list = pam_lists(:one)
  end

  test "should get index" do
    get pam_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_pam_list_url
    assert_response :success
  end

  test "should create pam_list" do
    assert_difference('PamList.count') do
      post pam_lists_url, params: { pam_list: { approved: @pam_list.approved, budget_id: @pam_list.budget_id, budget_not_applied: @pam_list.budget_not_applied, cost: @pam_list.cost, in_process: @pam_list.in_process, is_final_approved: @pam_list.is_final_approved, nr: @pam_list.nr, remained: @pam_list.remained } }
    end

    assert_redirected_to pam_list_url(PamList.last)
  end

  test "should show pam_list" do
    get pam_list_url(@pam_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_pam_list_url(@pam_list)
    assert_response :success
  end

  test "should update pam_list" do
    patch pam_list_url(@pam_list), params: { pam_list: { approved: @pam_list.approved, budget_id: @pam_list.budget_id, budget_not_applied: @pam_list.budget_not_applied, cost: @pam_list.cost, in_process: @pam_list.in_process, is_final_approved: @pam_list.is_final_approved, nr: @pam_list.nr, remained: @pam_list.remained } }
    assert_redirected_to pam_list_url(@pam_list)
  end

  test "should destroy pam_list" do
    assert_difference('PamList.count', -1) do
      delete pam_list_url(@pam_list)
    end

    assert_redirected_to pam_lists_url
  end
end
