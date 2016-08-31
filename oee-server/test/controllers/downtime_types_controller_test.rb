require 'test_helper'

class DowntimeTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @downtime_type = downtime_types(:one)
  end

  test "should get index" do
    get downtime_types_url
    assert_response :success
  end

  test "should get new" do
    get new_downtime_type_url
    assert_response :success
  end

  test "should create downtime_type" do
    assert_difference('DowntimeType.count') do
      post downtime_types_url, params: { downtime_type: { description: @downtime_type.description, name: @downtime_type.name, nr: @downtime_type.nr } }
    end

    assert_redirected_to downtime_type_url(DowntimeType.last)
  end

  test "should show downtime_type" do
    get downtime_type_url(@downtime_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_downtime_type_url(@downtime_type)
    assert_response :success
  end

  test "should update downtime_type" do
    patch downtime_type_url(@downtime_type), params: { downtime_type: { description: @downtime_type.description, name: @downtime_type.name, nr: @downtime_type.nr } }
    assert_redirected_to downtime_type_url(@downtime_type)
  end

  test "should destroy downtime_type" do
    assert_difference('DowntimeType.count', -1) do
      delete downtime_type_url(@downtime_type)
    end

    assert_redirected_to downtime_types_url
  end
end
