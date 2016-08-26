class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

  skip_before_action :require_user,only:[:new,:create]

  layout "no_authorization"

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # POST /resource/sign_in
  def create
    # super
    params[:user] = params[:user_session] if params[:user_session]
    resource = User.find_for_database_authentication(:email => params[:user][:email])
    return invalid_login_attempt unless resource
    if resource.valid_password?(params[:user][:password])
      sign_in(resource_name, resource)
      # render :json => {result: true, content: '登陆成功'}
      redirect_to '/', notice: '登陆成功.'
      return
    end
    invalid_login_attempt
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  protected
  def invalid_login_attempt
    warden.custom_failure!
    # render :json => {result: false, content: '错误的用户名或密码'}
    redirect_to new_user_session_path, notice: '错误的用户名或密码.'
  end
end
