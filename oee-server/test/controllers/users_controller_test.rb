require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { current_sign_in_at: @user.current_sign_in_at, current_sign_in_ip: @user.current_sign_in_ip, email: @user.email, encrypted_password: @user.encrypted_password, failed_attempts: @user.failed_attempts, is_system: @user.is_system, last_sign_in_at: @user.last_sign_in_at, last_sign_in_ip: @user.last_sign_in_ip, locked_at: @user.locked_at, name: @user.name, remember_created_at: @user.remember_created_at, reset_password_sent_at: @user.reset_password_sent_at, reset_password_token: @user.reset_password_token, role: @user.role, sign_in_count: @user.sign_in_count, unlock_token: @user.unlock_token } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { current_sign_in_at: @user.current_sign_in_at, current_sign_in_ip: @user.current_sign_in_ip, email: @user.email, encrypted_password: @user.encrypted_password, failed_attempts: @user.failed_attempts, is_system: @user.is_system, last_sign_in_at: @user.last_sign_in_at, last_sign_in_ip: @user.last_sign_in_ip, locked_at: @user.locked_at, name: @user.name, remember_created_at: @user.remember_created_at, reset_password_sent_at: @user.reset_password_sent_at, reset_password_token: @user.reset_password_token, role: @user.role, sign_in_count: @user.sign_in_count, unlock_token: @user.unlock_token } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
