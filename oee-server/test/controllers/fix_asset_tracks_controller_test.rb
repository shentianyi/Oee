require 'test_helper'

class FixAssetTracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fix_asset_track = fix_asset_tracks(:one)
  end

  test "should get index" do
    get fix_asset_tracks_url
    assert_response :success
  end

  test "should get new" do
    get new_fix_asset_track_url
    assert_response :success
  end

  test "should create fix_asset_track" do
    assert_difference('FixAssetTrack.count') do
      post fix_asset_tracks_url, params: { fix_asset_track: { apply_id: @fix_asset_track.apply_id, completed_id: @fix_asset_track.completed_id, description: @fix_asset_track.description, equipment_nr: @fix_asset_track.equipment_nr, equipment_track_id: @fix_asset_track.equipment_track_id, info_receive_date: @fix_asset_track.info_receive_date, is_add_equipment: @fix_asset_track.is_add_equipment, is_add_fix_asset: @fix_asset_track.is_add_fix_asset, nr: @fix_asset_track.nr, price: @fix_asset_track.price, procurment_date: @fix_asset_track.procurment_date, procurment_id: @fix_asset_track.procurment_id, project: @fix_asset_track.project, proposer: @fix_asset_track.proposer, qty: @fix_asset_track.qty, remark: @fix_asset_track.remark, status: @fix_asset_track.status, supplier: @fix_asset_track.supplier } }
    end

    assert_redirected_to fix_asset_track_url(FixAssetTrack.last)
  end

  test "should show fix_asset_track" do
    get fix_asset_track_url(@fix_asset_track)
    assert_response :success
  end

  test "should get edit" do
    get edit_fix_asset_track_url(@fix_asset_track)
    assert_response :success
  end

  test "should update fix_asset_track" do
    patch fix_asset_track_url(@fix_asset_track), params: { fix_asset_track: { apply_id: @fix_asset_track.apply_id, completed_id: @fix_asset_track.completed_id, description: @fix_asset_track.description, equipment_nr: @fix_asset_track.equipment_nr, equipment_track_id: @fix_asset_track.equipment_track_id, info_receive_date: @fix_asset_track.info_receive_date, is_add_equipment: @fix_asset_track.is_add_equipment, is_add_fix_asset: @fix_asset_track.is_add_fix_asset, nr: @fix_asset_track.nr, price: @fix_asset_track.price, procurment_date: @fix_asset_track.procurment_date, procurment_id: @fix_asset_track.procurment_id, project: @fix_asset_track.project, proposer: @fix_asset_track.proposer, qty: @fix_asset_track.qty, remark: @fix_asset_track.remark, status: @fix_asset_track.status, supplier: @fix_asset_track.supplier } }
    assert_redirected_to fix_asset_track_url(@fix_asset_track)
  end

  test "should destroy fix_asset_track" do
    assert_difference('FixAssetTrack.count', -1) do
      delete fix_asset_track_url(@fix_asset_track)
    end

    assert_redirected_to fix_asset_tracks_url
  end
end
