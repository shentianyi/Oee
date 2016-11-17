class EquipmentDepreciationsController < ApplicationController
  before_action :set_equipment_depreciation, only: [:show, :edit, :update, :destroy]

  # GET /equipment_depreciations
  # GET /equipment_depreciations.json
  def index
    @equipment_depreciations = EquipmentDepreciation.all.paginate(page: params[:page])
  end

  # GET /equipment_depreciations/1
  # GET /equipment_depreciations/1.json
  def show
  end

  # GET /equipment_depreciations/new
  def new
    @equipment_depreciation = EquipmentDepreciation.new
  end

  # GET /equipment_depreciations/1/edit
  def edit
  end

  # POST /equipment_depreciations
  # POST /equipment_depreciations.json
  def create
    @equipment_depreciation = EquipmentDepreciation.new(equipment_depreciation_params)

    respond_to do |format|
      if @equipment_depreciation.save
        format.html { redirect_to @equipment_depreciation, notice: 'Equipment depreciation was successfully created.' }
        format.json { render :show, status: :created, location: @equipment_depreciation }
      else
        format.html { render :new }
        format.json { render json: @equipment_depreciation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equipment_depreciations/1
  # PATCH/PUT /equipment_depreciations/1.json
  def update
    respond_to do |format|
      if @equipment_depreciation.update(equipment_depreciation_params)
        format.html { redirect_to @equipment_depreciation, notice: 'Equipment depreciation was successfully updated.' }
        format.json { render :show, status: :ok, location: @equipment_depreciation }
      else
        format.html { render :edit }
        format.json { render json: @equipment_depreciation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipment_depreciations/1
  # DELETE /equipment_depreciations/1.json
  def destroy
    @equipment_depreciation.destroy
    respond_to do |format|
      format.html { redirect_to equipment_depreciations_url, notice: 'Equipment depreciation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    if request.post?
      puts "--------------------------------------"
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::EquipmentDepreciationHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipment_depreciation
      @equipment_depreciation = EquipmentDepreciation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def equipment_depreciation_params
      params.require(:equipment_depreciation).permit(:depreciation_time, :original_val, :depreciation_val, :net_val, :equipment_track_id)
    end
end
