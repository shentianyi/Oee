class UserInventoryTasksController < ApplicationController
  before_action :set_user_inventory_task, only: [:show, :edit, :update, :destroy]

  # GET /user_inventory_tasks
  # GET /user_inventory_tasks.json
  def index
    @http_host=request.env["HTTP_HOST"]
    @user_inventory_tasks = UserInventoryTask.all.paginate(page: params[:page])
  end

  # GET /user_inventory_tasks/1
  # GET /user_inventory_tasks/1.json
  def show
  end

  # GET /user_inventory_tasks/new
  def new
    @user_inventory_task = UserInventoryTask.new
  end

  # GET /user_inventory_tasks/1/edit
  def edit
  end

  # POST /user_inventory_tasks
  # POST /user_inventory_tasks.json
  def create
    @user_inventory_task = UserInventoryTask.new(user_inventory_task_params)

    respond_to do |format|
      if @user_inventory_task.save
        format.html { redirect_to @user_inventory_task, notice: 'User inventory task was successfully created.' }
        format.json { render :show, status: :created, location: @user_inventory_task }
      else
        format.html { render :new }
        format.json { render json: @user_inventory_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_inventory_tasks/1
  # PATCH/PUT /user_inventory_tasks/1.json
  def update
    respond_to do |format|
      if @user_inventory_task.update(user_inventory_task_params)
        format.html { redirect_to @user_inventory_task, notice: 'User inventory task was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_inventory_task }
      else
        format.html { render :edit }
        format.json { render json: @user_inventory_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_inventory_tasks/1
  # DELETE /user_inventory_tasks/1.json
  def destroy
    @user_inventory_task.destroy
    respond_to do |format|
      format.html { redirect_to user_inventory_tasks_url, notice: 'User inventory task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_inventory_task
      @user_inventory_task = UserInventoryTask.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_inventory_task_params
      params.require(:user_inventory_task).permit(:user_id, :inventory_list_id, :start_time, :end_time, :type, :target_qty, :real_qty)
    end
end
