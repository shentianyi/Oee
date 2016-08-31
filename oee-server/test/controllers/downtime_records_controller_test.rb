require 'test_helper'

class DowntimeRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @downtime_record = downtime_records(:one)
  end

  test "should get index" do
    get downtime_records_url
    assert_response :success
  end

  test "should get new" do
    get new_downtime_record_url
    assert_response :success
  end

  test "should create downtime_record" do
    assert_difference('DowntimeRecord.count') do
      post downtime_records_url, params: { downtime_record: { craft_id: @downtime_record.craft_id, downtime_code_id: @downtime_record.downtime_code_id, fors_faufnr: @downtime_record.fors_faufnr, fors_faufpo: @downtime_record.fors_faufpo, fors_lnr: @downtime_record.fors_lnr, fors_werk: @downtime_record.fors_werk, is_naturl: @downtime_record.is_naturl, machine_id: @downtime_record.machine_id, pd_auss_prod: @downtime_record.pd_auss_prod, pd_auss_ruest: @downtime_record.pd_auss_ruest, pd_bemerk: @downtime_record.pd_bemerk, pd_bis: @downtime_record.pd_bis, pd_erf_dat: @downtime_record.pd_erf_dat, pd_laenge: @downtime_record.pd_laenge, pd_rf: @downtime_record.pd_rf, pd_std: @downtime_record.pd_std, pd_stueck: @downtime_record.pd_stueck, pd_teb: @downtime_record.pd_teb, pd_user: @downtime_record.pd_user, pd_von: @downtime_record.pd_von, pk_datum: @downtime_record.pk_datum, pk_sch: @downtime_record.pk_sch, pk_sch_std: @downtime_record.pk_sch_std, pk_sch_t: @downtime_record.pk_sch_t } }
    end

    assert_redirected_to downtime_record_url(DowntimeRecord.last)
  end

  test "should show downtime_record" do
    get downtime_record_url(@downtime_record)
    assert_response :success
  end

  test "should get edit" do
    get edit_downtime_record_url(@downtime_record)
    assert_response :success
  end

  test "should update downtime_record" do
    patch downtime_record_url(@downtime_record), params: { downtime_record: { craft_id: @downtime_record.craft_id, downtime_code_id: @downtime_record.downtime_code_id, fors_faufnr: @downtime_record.fors_faufnr, fors_faufpo: @downtime_record.fors_faufpo, fors_lnr: @downtime_record.fors_lnr, fors_werk: @downtime_record.fors_werk, is_naturl: @downtime_record.is_naturl, machine_id: @downtime_record.machine_id, pd_auss_prod: @downtime_record.pd_auss_prod, pd_auss_ruest: @downtime_record.pd_auss_ruest, pd_bemerk: @downtime_record.pd_bemerk, pd_bis: @downtime_record.pd_bis, pd_erf_dat: @downtime_record.pd_erf_dat, pd_laenge: @downtime_record.pd_laenge, pd_rf: @downtime_record.pd_rf, pd_std: @downtime_record.pd_std, pd_stueck: @downtime_record.pd_stueck, pd_teb: @downtime_record.pd_teb, pd_user: @downtime_record.pd_user, pd_von: @downtime_record.pd_von, pk_datum: @downtime_record.pk_datum, pk_sch: @downtime_record.pk_sch, pk_sch_std: @downtime_record.pk_sch_std, pk_sch_t: @downtime_record.pk_sch_t } }
    assert_redirected_to downtime_record_url(@downtime_record)
  end

  test "should destroy downtime_record" do
    assert_difference('DowntimeRecord.count', -1) do
      delete downtime_record_url(@downtime_record)
    end

    assert_redirected_to downtime_records_url
  end
end
