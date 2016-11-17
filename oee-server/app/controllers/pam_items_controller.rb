class PamItemsController < ApplicationController
  before_action :set_pam_item, only: [:show, :edit, :update, :destroy]

  # GET /pam_items
  # GET /pam_items.json
  def index
    @pam_items = PamItem.all.paginate(page: params[:page])
  end

  # GET /pam_items/1
  # GET /pam_items/1.json
  def show
  end

  # GET /pam_items/new
  def new
    @pam_item = PamItem.new
  end

  # GET /pam_items/1/edit
  def edit
  end

  # POST /pam_items
  # POST /pam_items.json
  def create
    @pam_item = PamItem.new(pam_item_params)

    respond_to do |format|
      if @pam_item.save
        format.html { redirect_to @pam_item, notice: 'Pam item was successfully created.' }
        format.json { render :show, status: :created, location: @pam_item }
      else
        format.html { render :new }
        format.json { render json: @pam_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pam_items/1
  # PATCH/PUT /pam_items/1.json
  def update
    respond_to do |format|
      if @pam_item.update(pam_item_params)
        format.html { redirect_to @pam_item, notice: 'Pam item was successfully updated.' }
        format.json { render :show, status: :ok, location: @pam_item }
      else
        format.html { render :edit }
        format.json { render json: @pam_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pam_items/1
  # DELETE /pam_items/1.json
  def destroy
    @pam_item.destroy
    respond_to do |format|
      format.html { redirect_to pam_items_url, notice: 'Pam item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def purchase_import
    if request.post?
      puts "--------------------------------------"
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::PamItemHandler.purchase_import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def ts_import
    if request.post?
      puts "--------------------------------------"
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::PamItemHandler.ts_import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def finance_import
    if request.post?
      puts "--------------------------------------"
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::PamItemHandler.finance_import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pam_item
      @pam_item = PamItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pam_item_params
      params.require(:pam_item).permit(:pa_no, :description, :qty, :total_cost, :applicant, :applicant_date, :supplier, :sap_no, :arrive_date, :final_release, :po_no, :po_cost, :invoice_prepared, :invoice_amount, :completed_date, :completed_id, :completed_status, :completed_amount, :booking_status, :final_cost, :pam_list_id)
    end
end
