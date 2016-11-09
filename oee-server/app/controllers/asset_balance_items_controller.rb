class AssetBalanceItemsController < ApplicationController
  before_action :set_asset_balance_item, only: [:show, :edit, :update, :destroy]

  # GET /asset_balance_items
  # GET /asset_balance_items.json
  def index
    @asset_balance_items = AssetBalanceItem.all
  end

  # GET /asset_balance_items/1
  # GET /asset_balance_items/1.json
  def show
  end

  # GET /asset_balance_items/new
  def new
    @asset_balance_item = AssetBalanceItem.new
  end

  # GET /asset_balance_items/1/edit
  def edit
  end

  # POST /asset_balance_items
  # POST /asset_balance_items.json
  def create
    @asset_balance_item = AssetBalanceItem.new(asset_balance_item_params)

    respond_to do |format|
      if @asset_balance_item.save
        format.html { redirect_to @asset_balance_item, notice: 'Asset balance item was successfully created.' }
        format.json { render :show, status: :created, location: @asset_balance_item }
      else
        format.html { render :new }
        format.json { render json: @asset_balance_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /asset_balance_items/1
  # PATCH/PUT /asset_balance_items/1.json
  def update
    respond_to do |format|
      if @asset_balance_item.update(asset_balance_item_params)
        format.html { redirect_to @asset_balance_item, notice: 'Asset balance item was successfully updated.' }
        format.json { render :show, status: :ok, location: @asset_balance_item }
      else
        format.html { render :edit }
        format.json { render json: @asset_balance_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /asset_balance_items/1
  # DELETE /asset_balance_items/1.json
  def destroy
    @asset_balance_item.destroy
    respond_to do |format|
      format.html { redirect_to asset_balance_items_url, notice: 'Asset balance item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset_balance_item
      @asset_balance_item = AssetBalanceItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_balance_item_params
      params.require(:asset_balance_item).permit(:fix_asset_track_id, :cap_date, :profit_center, :asset_description, :acquis_val,
                                                 :accum_dep, :book_val, :asset_class, :inventory_nr, :ts_equipment_nr,
                                                 :ts_project, :ts_inventory_user, :ts_keeper, :ts_position, :ts_nameplate_track,
                                                 :ts_type, :ts_equipment_type, :ts_area, :ts_supplier, :status,
                                                 :remark, :ts_inventory_result)
    end
end
