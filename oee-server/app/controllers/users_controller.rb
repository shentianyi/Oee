class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if current_user && current_user.admin?
      @users=User.all.paginate(:page => params[:page])
    else
      # render :json => "404 页面未找到"
      render file: "#{Rails.root}/public/404.html" , status: 404
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    # if @user.save
    #   render json: {user: @user, content: '成功创建新用户', result: true}
    # else
    #   render json: {content: @user.errors.messages.values.uniq.join('/'), result: false}
    # end
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: '成功创建新用户.' }
        format.json { render :show, status: :created, user: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: '更新成功.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: '删除成功.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :role, :is_system, :email, :encrypted_password, :password, :password_confirmation, :group_id)
    end
end
