class InventoryItemsController < ApplicationController
  before_action :set_inventory_item, only: [:show, :edit, :update, :destroy]
  before_action :set_inventory_list, only: [:cover_list]

  # GET /inventory_items
  # GET /inventory_items.json
  def index
    @inventory_items = InventoryItem.all
  end

  # GET /inventory_items/1
  # GET /inventory_items/1.json
  def show
  end

  # GET /inventory_items/new
  def new
    @inventory_item = InventoryItem.new
  end

  # GET /inventory_items/1/edit
  def edit
  end

  # POST /inventory_items
  # POST /inventory_items.json
  def create
    @inventory_item = InventoryItem.new(inventory_item_params)

    respond_to do |format|
      if @inventory_item.save
        format.html { redirect_to @inventory_item, notice: 'Inventory item was successfully created.' }
        format.json { render :show, status: :created, location: @inventory_item }
      else
        format.html { render :new }
        format.json { render json: @inventory_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventory_items/1
  # PATCH/PUT /inventory_items/1.json
  def update
    respond_to do |format|
      if @inventory_item.update(inventory_item_params)
        format.html { redirect_to @inventory_item, notice: 'Inventory item was successfully updated.' }
        format.json { render :show, status: :ok, location: @inventory_item }
      else
        format.html { render :edit }
        format.json { render json: @inventory_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_items/1
  # DELETE /inventory_items/1.json
  def destroy
    @inventory_item.destroy
    respond_to do |format|
      format.html { redirect_to inventory_items_url, notice: 'Inventory item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def cover_list
    InventoryItem.transaction do
      @inventory_list.inventory_items.where(is_cover: false).each do |item|
        message= item.cover_item
        if message.result
          item.update_attributes(is_cover: true)
        else
          item.update_attributes(remark: message.content)
        end
      end
    end
    @inventory_items=@inventory_list.inventory_items#.paginate(:page => params[:page])
    #@page_start=(params[:page].nil? ? 0 : (params[:page].to_i-1))*20

    render 'inventory_lists/inventory_items'
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_inventory_item
    @inventory_item = InventoryItem.find(params[:id])
  end

  def set_inventory_list
    @inventory_list = InventoryList.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def inventory_item_params
    params.require(:inventory_item).permit(:inventory_list_id, :fix_asset_track_id, :cap_date, :profit_center, :asset_description, :acquis_val, :accum_dep, :book_val, :ts_equipment_nr,
                                           :ts_project, :ts_inventory_user_id, :ts_keeper, :ts_position, :ts_nameplate_track, :ts_type, :ts_equipment_type, :ts_area_id, :ts_supplier,
                                           :status, :remark, :ts_inventory_result, :current_area_id)
  end
end
