require 'test_helper'

class BuMangersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bu_manger = bu_mangers(:one)
  end

  test "should get index" do
    get bu_mangers_url
    assert_response :success
  end

  test "should get new" do
    get new_bu_manger_url
    assert_response :success
  end

  test "should create bu_manger" do
    assert_difference('BuManger.count') do
      post bu_mangers_url, params: { bu_manger: { desc: @bu_manger.desc, finance_nr: @bu_manger.finance_nr, name: @bu_manger.name, nr: @bu_manger.nr } }
    end

    assert_redirected_to bu_manger_url(BuManger.last)
  end

  test "should show bu_manger" do
    get bu_manger_url(@bu_manger)
    assert_response :success
  end

  test "should get edit" do
    get edit_bu_manger_url(@bu_manger)
    assert_response :success
  end

  test "should update bu_manger" do
    patch bu_manger_url(@bu_manger), params: { bu_manger: { desc: @bu_manger.desc, finance_nr: @bu_manger.finance_nr, name: @bu_manger.name, nr: @bu_manger.nr } }
    assert_redirected_to bu_manger_url(@bu_manger)
  end

  test "should destroy bu_manger" do
    assert_difference('BuManger.count', -1) do
      delete bu_manger_url(@bu_manger)
    end

    assert_redirected_to bu_mangers_url
  end
end
