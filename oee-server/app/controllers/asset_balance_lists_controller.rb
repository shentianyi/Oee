class AssetBalanceListsController < ApplicationController
  before_action :set_asset_balance_list, only: [:show, :edit, :update, :destroy, :asset_balance_items, :child_search]

  # GET /asset_balance_lists
  # GET /asset_balance_lists.json
  def index
    @asset_balance_lists = AssetBalanceList.all.paginate(page: params[:page])
  end

  # GET /asset_balance_lists/1
  # GET /asset_balance_lists/1.json
  def show
  end

  # GET /asset_balance_lists/new
  def new
    @asset_balance_list = AssetBalanceList.new
  end

  # GET /asset_balance_lists/1/edit
  def edit
  end

  # POST /asset_balance_lists
  # POST /asset_balance_lists.json
  def create
    @asset_balance_list = AssetBalanceList.new(asset_balance_list_params)

    respond_to do |format|
      if @asset_balance_list.save
        format.html { redirect_to @asset_balance_list, notice: 'Asset balance list was successfully created.' }
        format.json { render :show, status: :created, location: @asset_balance_list }
      else
        format.html { render :new }
        format.json { render json: @asset_balance_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /asset_balance_lists/1
  # PATCH/PUT /asset_balance_lists/1.json
  def update
    respond_to do |format|
      if @asset_balance_list.update(asset_balance_list_params)
        format.html { redirect_to @asset_balance_list, notice: 'Asset balance list was successfully updated.' }
        format.json { render :show, status: :ok, location: @asset_balance_list }
      else
        format.html { render :edit }
        format.json { render json: @asset_balance_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /asset_balance_lists/1
  # DELETE /asset_balance_lists/1.json
  def destroy
    @asset_balance_list.destroy
    respond_to do |format|
      format.html { redirect_to asset_balance_lists_url, notice: 'Asset balance list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    if request.get?
      @asset_balance_list=AssetBalanceList.find_by_id(params[:id])
      session[:asset_balance_list_id]=params[:id]
    else
      @asset_balance_list=AssetBalanceList.find_by_id(session[:asset_balance_list_id])

      puts "--------------------------------------"
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::AssetBalanceItemHandler.import(fd, @asset_balance_list)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def asset_balance_items
    @asset_balance_items = @asset_balance_list.asset_balance_items.paginate(:page => params[:page])
    @page_start=(params[:page].nil? ? 0 : (params[:page].to_i-1))*20
  end

  def child_search
    condition = {}

    unless params[:asset_balance_item][:nr].blank?
      condition[:fix_asset_track_id] = FixAssetTrack.where("nr like ?", "%#{params[:asset_balance_item][:nr]}%").pluck(:id)
      instance_variable_set("@nr", params[:asset_balance_item][:nr])
    end

    unless params[:asset_balance_item][:ts_area_id].blank?
      condition[:ts_area_id] = params[:asset_balance_item][:ts_area_id]
      instance_variable_set("@ts_area_id", params[:asset_balance_item][:ts_area_id])
    end

    @asset_balance_items = @asset_balance_list.asset_balance_items.where(condition).paginate(:page => params[:page])
    @page_start=(params[:page].nil? ? 0 : (params[:page].to_i-1))*20

    render :asset_balance_items
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_asset_balance_list
    @asset_balance_list = AssetBalanceList.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def asset_balance_list_params
    params.require(:asset_balance_list).permit(:balance_date)
  end
end
