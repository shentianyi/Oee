require 'test_helper'

class CapexesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @capex = capexes(:one)
  end

  test "should get index" do
    get capexes_url
    assert_response :success
  end

  test "should get new" do
    get new_capex_url
    assert_response :success
  end

  test "should create capex" do
    assert_difference('Capex.count') do
      post capexes_url, params: { capex: { bu_code: @capex.bu_code, desc: @capex.desc, project: @capex.project } }
    end

    assert_redirected_to capex_url(Capex.last)
  end

  test "should show capex" do
    get capex_url(@capex)
    assert_response :success
  end

  test "should get edit" do
    get edit_capex_url(@capex)
    assert_response :success
  end

  test "should update capex" do
    patch capex_url(@capex), params: { capex: { bu_code: @capex.bu_code, desc: @capex.desc, project: @capex.project } }
    assert_redirected_to capex_url(@capex)
  end

  test "should destroy capex" do
    assert_difference('Capex.count', -1) do
      delete capex_url(@capex)
    end

    assert_redirected_to capexes_url
  end
end
