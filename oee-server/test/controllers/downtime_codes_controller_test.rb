require 'test_helper'

class DowntimeCodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @downtime_code = downtime_codes(:one)
  end

  test "should get index" do
    get downtime_codes_url
    assert_response :success
  end

  test "should get new" do
    get new_downtime_code_url
    assert_response :success
  end

  test "should create downtime_code" do
    assert_difference('DowntimeCode.count') do
      post downtime_codes_url, params: { downtime_code: { description: @downtime_code.description, downtime_type_id: @downtime_code.downtime_type_id, nr: @downtime_code.nr } }
    end

    assert_redirected_to downtime_code_url(DowntimeCode.last)
  end

  test "should show downtime_code" do
    get downtime_code_url(@downtime_code)
    assert_response :success
  end

  test "should get edit" do
    get edit_downtime_code_url(@downtime_code)
    assert_response :success
  end

  test "should update downtime_code" do
    patch downtime_code_url(@downtime_code), params: { downtime_code: { description: @downtime_code.description, downtime_type_id: @downtime_code.downtime_type_id, nr: @downtime_code.nr } }
    assert_redirected_to downtime_code_url(@downtime_code)
  end

  test "should destroy downtime_code" do
    assert_difference('DowntimeCode.count', -1) do
      delete downtime_code_url(@downtime_code)
    end

    assert_redirected_to downtime_codes_url
  end
end
