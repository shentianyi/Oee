class UserAreaItemsController < ApplicationController
  before_action :set_user_area_item, only: [:show, :edit, :update, :destroy]

  # GET /user_area_items
  # GET /user_area_items.json
  def index
    @user_area_items = UserAreaItem.all
  end

  # GET /user_area_items/1
  # GET /user_area_items/1.json
  def show
  end

  # GET /user_area_items/new
  def new
    @user_area_item = UserAreaItem.new
  end

  # GET /user_area_items/1/edit
  def edit
  end

  # POST /user_area_items
  # POST /user_area_items.json
  def create
    @user_area_item = UserAreaItem.new(user_area_item_params)

    respond_to do |format|
      if @user_area_item.save
        format.html { redirect_to @user_area_item, notice: 'User area item was successfully created.' }
        format.json { render :show, status: :created, location: @user_area_item }
      else
        format.html { render :new }
        format.json { render json: @user_area_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_area_items/1
  # PATCH/PUT /user_area_items/1.json
  def update
    respond_to do |format|
      if @user_area_item.update(user_area_item_params)
        format.html { redirect_to @user_area_item, notice: 'User area item was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_area_item }
      else
        format.html { render :edit }
        format.json { render json: @user_area_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_area_items/1
  # DELETE /user_area_items/1.json
  def destroy
    @user_area_item.destroy
    respond_to do |format|
      format.html { redirect_to user_area_items_url, notice: 'User area item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_area_item
      @user_area_item = UserAreaItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_area_item_params
      params.require(:user_area_item).permit(:user_id, :area_id)
    end
end
