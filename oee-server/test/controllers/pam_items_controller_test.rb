require 'test_helper'

class PamItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pam_item = pam_items(:one)
  end

  test "should get index" do
    get pam_items_url
    assert_response :success
  end

  test "should get new" do
    get new_pam_item_url
    assert_response :success
  end

  test "should create pam_item" do
    assert_difference('PamItem.count') do
      post pam_items_url, params: { pam_item: { applicant: @pam_item.applicant, applicant_date: @pam_item.applicant_date, arrive_date: @pam_item.arrive_date, booking_status: @pam_item.booking_status, completed_amount: @pam_item.completed_amount, completed_date: @pam_item.completed_date, completed_id: @pam_item.completed_id, completed_status: @pam_item.completed_status, description: @pam_item.description, final_cost: @pam_item.final_cost, final_release: @pam_item.final_release, invoice_amount: @pam_item.invoice_amount, invoice_prepared: @pam_item.invoice_prepared, pa_no: @pam_item.pa_no, pam_list_id: @pam_item.pam_list_id, po_cost: @pam_item.po_cost, po_no: @pam_item.po_no, qty: @pam_item.qty, sap_no: @pam_item.sap_no, supplier: @pam_item.supplier, total_cost: @pam_item.total_cost } }
    end

    assert_redirected_to pam_item_url(PamItem.last)
  end

  test "should show pam_item" do
    get pam_item_url(@pam_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_pam_item_url(@pam_item)
    assert_response :success
  end

  test "should update pam_item" do
    patch pam_item_url(@pam_item), params: { pam_item: { applicant: @pam_item.applicant, applicant_date: @pam_item.applicant_date, arrive_date: @pam_item.arrive_date, booking_status: @pam_item.booking_status, completed_amount: @pam_item.completed_amount, completed_date: @pam_item.completed_date, completed_id: @pam_item.completed_id, completed_status: @pam_item.completed_status, description: @pam_item.description, final_cost: @pam_item.final_cost, final_release: @pam_item.final_release, invoice_amount: @pam_item.invoice_amount, invoice_prepared: @pam_item.invoice_prepared, pa_no: @pam_item.pa_no, pam_list_id: @pam_item.pam_list_id, po_cost: @pam_item.po_cost, po_no: @pam_item.po_no, qty: @pam_item.qty, sap_no: @pam_item.sap_no, supplier: @pam_item.supplier, total_cost: @pam_item.total_cost } }
    assert_redirected_to pam_item_url(@pam_item)
  end

  test "should destroy pam_item" do
    assert_difference('PamItem.count', -1) do
      delete pam_item_url(@pam_item)
    end

    assert_redirected_to pam_items_url
  end
end
