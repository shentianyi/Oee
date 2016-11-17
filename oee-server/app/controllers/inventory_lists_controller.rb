class InventoryListsController < ApplicationController
  before_action :set_inventory_list, only: [:show, :edit, :update, :destroy, :inventory_items]

  # GET /inventory_lists
  # GET /inventory_lists.json
  def index
    @inventory_lists = InventoryList.all.paginate(page: params[:page])
  end

  # GET /inventory_lists/1
  # GET /inventory_lists/1.json
  def show
  end

  # GET /inventory_lists/new
  def new
    @inventory_list = InventoryList.new
  end

  # GET /inventory_lists/1/edit
  def edit
  end

  # POST /inventory_lists
  # POST /inventory_lists.json
  def create
    @inventory_list = InventoryList.new(inventory_list_params)

    respond_to do |format|
      if @inventory_list.save
        format.html { redirect_to @inventory_list, notice: 'Inventory list was successfully created.' }
        format.json { render :show, status: :created, location: @inventory_list }
      else
        format.html { render :new }
        format.json { render json: @inventory_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventory_lists/1
  # PATCH/PUT /inventory_lists/1.json
  def update
    respond_to do |format|
      if @inventory_list.update(inventory_list_params)
        format.html { redirect_to @inventory_list, notice: 'Inventory list was successfully updated.' }
        format.json { render :show, status: :ok, location: @inventory_list }
      else
        format.html { render :edit }
        format.json { render json: @inventory_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_lists/1
  # DELETE /inventory_lists/1.json
  def destroy
    @inventory_list.destroy
    respond_to do |format|
      format.html { redirect_to inventory_lists_url, notice: 'Inventory list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def inventory_items
    @inventory_items = @inventory_list.inventory_items
  end

  def import
    if request.post?
      @inventory_list = InventoryList.find_by_id(session[:inventory_list_id])

      puts "--------------------------------------"
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::InventoryItemHandler.import(fd, @inventory_list)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    else
      @inventory_list = InventoryList.find_by_id(params[:id])
      session[:inventory_list_id]=params[:id]
    end
  end

  def reset_inventory
    p params
    last_batch=0
    inventory_list = InventoryList.find_by_id(params[:id])
    if inventory_list && (item = inventory_list.asset_balance_list.asset_balance_items.unscoped.order(lock_batch: :desc).first)
      last_batch = item.lock_batch
    end

    if params[:do] == 'disable'
      flash[:notice] = '重置成功'
      lock_remark='盘点覆盖锁定'+"-"+Time.now.strftime("%Y%m%d")
      AssetBalanceItem.transaction do
        inventory_list.asset_balance_list.asset_balance_items.where(locked: false).update_all({
                                                                                                  lock_remark: lock_remark,
                                                                                                  locked: true,
                                                                                                  lock_user_id: current_user.id,
                                                                                                  lock_batch: last_batch+1,
                                                                                                  lock_at: Time.now.utc
                                                                                              })
      end
    else
      flash[:notice] = '取消重置成功'
      AssetBalanceItem.transaction do
        inventory_list.asset_balance_list.asset_balance_items.unscoped.where(locked: true, lock_batch: last_batch).update_all({
                                                                                                                                  locked: false,
                                                                                                                                  lock_remark: nil,
                                                                                                                                  lock_user_id: nil,
                                                                                                                                  lock_at: nil
                                                                                                                              })
      end
    end

    redirect_to action: :index
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory_list
      @inventory_list = InventoryList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inventory_list_params
      params.require(:inventory_list).permit(:name, :inventory_date, :asset_balance_list_id, :status)
    end
end
