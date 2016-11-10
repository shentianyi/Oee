require 'test_helper'

class InventoryFilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inventory_file = inventory_files(:one)
  end

  test "should get index" do
    get inventory_files_url
    assert_response :success
  end

  test "should get new" do
    get new_inventory_file_url
    assert_response :success
  end

  test "should create inventory_file" do
    assert_difference('InventoryFile.count') do
      post inventory_files_url, params: { inventory_file: { name: @inventory_file.name, path: @inventory_file.path, size: @inventory_file.size } }
    end

    assert_redirected_to inventory_file_url(InventoryFile.last)
  end

  test "should show inventory_file" do
    get inventory_file_url(@inventory_file)
    assert_response :success
  end

  test "should get edit" do
    get edit_inventory_file_url(@inventory_file)
    assert_response :success
  end

  test "should update inventory_file" do
    patch inventory_file_url(@inventory_file), params: { inventory_file: { name: @inventory_file.name, path: @inventory_file.path, size: @inventory_file.size } }
    assert_redirected_to inventory_file_url(@inventory_file)
  end

  test "should destroy inventory_file" do
    assert_difference('InventoryFile.count', -1) do
      delete inventory_file_url(@inventory_file)
    end

    assert_redirected_to inventory_files_url
  end
end
