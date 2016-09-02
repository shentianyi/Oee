require 'test_helper'

class WorkShiftsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @work_shift = work_shifts(:one)
  end

  test "should get index" do
    get work_shifts_url
    assert_response :success
  end

  test "should get new" do
    get new_work_shift_url
    assert_response :success
  end

  test "should create work_shift" do
    assert_difference('WorkShift.count') do
      post work_shifts_url, params: { work_shift: { end_time: @work_shift.end_time, name: @work_shift.name, nr: @work_shift.nr, start_time: @work_shift.start_time } }
    end

    assert_redirected_to work_shift_url(WorkShift.last)
  end

  test "should show work_shift" do
    get work_shift_url(@work_shift)
    assert_response :success
  end

  test "should get edit" do
    get edit_work_shift_url(@work_shift)
    assert_response :success
  end

  test "should update work_shift" do
    patch work_shift_url(@work_shift), params: { work_shift: { end_time: @work_shift.end_time, name: @work_shift.name, nr: @work_shift.nr, start_time: @work_shift.start_time } }
    assert_redirected_to work_shift_url(@work_shift)
  end

  test "should destroy work_shift" do
    assert_difference('WorkShift.count', -1) do
      delete work_shift_url(@work_shift)
    end

    assert_redirected_to work_shifts_url
  end
end
