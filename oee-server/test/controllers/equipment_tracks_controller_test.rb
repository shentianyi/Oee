require 'test_helper'

class EquipmentTracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equipment_track = equipment_tracks(:one)
  end

  test "should get index" do
    get equipment_tracks_url
    assert_response :success
  end

  test "should get new" do
    get new_equipment_track_url
    assert_response :success
  end

  test "should create equipment_track" do
    assert_difference('EquipmentTrack.count') do
      post equipment_tracks_url, params: { equipment_track: { area: @equipment_track.area, asset_nr: @equipment_track.asset_nr, department: @equipment_track.department, description: @equipment_track.description, equipment_serial_id: @equipment_track.equipment_serial_id, is_top: @equipment_track.is_top, level: @equipment_track.level, location: @equipment_track.location, name: @equipment_track.name, next_release: @equipment_track.next_release, nr: @equipment_track.nr, position: @equipment_track.position, procurment_date: @equipment_track.procurment_date, product_id: @equipment_track.product_id, profit_center: @equipment_track.profit_center, project: @equipment_track.project, release_cycle: @equipment_track.release_cycle, release_notice: @equipment_track.release_notice, remark: @equipment_track.remark, responsibilityer: @equipment_track.responsibilityer, status: @equipment_track.status, supplier: @equipment_track.supplier, type: @equipment_track.type } }
    end

    assert_redirected_to equipment_track_url(EquipmentTrack.last)
  end

  test "should show equipment_track" do
    get equipment_track_url(@equipment_track)
    assert_response :success
  end

  test "should get edit" do
    get edit_equipment_track_url(@equipment_track)
    assert_response :success
  end

  test "should update equipment_track" do
    patch equipment_track_url(@equipment_track), params: { equipment_track: { area: @equipment_track.area, asset_nr: @equipment_track.asset_nr, department: @equipment_track.department, description: @equipment_track.description, equipment_serial_id: @equipment_track.equipment_serial_id, is_top: @equipment_track.is_top, level: @equipment_track.level, location: @equipment_track.location, name: @equipment_track.name, next_release: @equipment_track.next_release, nr: @equipment_track.nr, position: @equipment_track.position, procurment_date: @equipment_track.procurment_date, product_id: @equipment_track.product_id, profit_center: @equipment_track.profit_center, project: @equipment_track.project, release_cycle: @equipment_track.release_cycle, release_notice: @equipment_track.release_notice, remark: @equipment_track.remark, responsibilityer: @equipment_track.responsibilityer, status: @equipment_track.status, supplier: @equipment_track.supplier, type: @equipment_track.type } }
    assert_redirected_to equipment_track_url(@equipment_track)
  end

  test "should destroy equipment_track" do
    assert_difference('EquipmentTrack.count', -1) do
      delete equipment_track_url(@equipment_track)
    end

    assert_redirected_to equipment_tracks_url
  end
end
