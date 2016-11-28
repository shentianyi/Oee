class EquipmentStatusesController < ApplicationController
  before_action :set_equipment_status, only: [:show, :edit, :update, :destroy]

  # GET /equipment_statuses
  # GET /equipment_statuses.json
  def index
    @equipment_statuses = EquipmentStatus.all
  end

  # GET /equipment_statuses/1
  # GET /equipment_statuses/1.json
  def show
  end

  # GET /equipment_statuses/new
  def new
    @equipment_status = EquipmentStatus.new
  end

  # GET /equipment_statuses/1/edit
  def edit
  end

  # POST /equipment_statuses
  # POST /equipment_statuses.json
  def create
    @equipment_status = EquipmentStatus.new(equipment_status_params)

    respond_to do |format|
      if @equipment_status.save
        format.html { redirect_to @equipment_status, notice: 'Equipment status was successfully created.' }
        format.json { render :show, status: :created, location: @equipment_status }
      else
        format.html { render :new }
        format.json { render json: @equipment_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equipment_statuses/1
  # PATCH/PUT /equipment_statuses/1.json
  def update
    respond_to do |format|
      if @equipment_status.update(equipment_status_params)
        format.html { redirect_to @equipment_status, notice: 'Equipment status was successfully updated.' }
        format.json { render :show, status: :ok, location: @equipment_status }
      else
        format.html { render :edit }
        format.json { render json: @equipment_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipment_statuses/1
  # DELETE /equipment_statuses/1.json
  def destroy
    @equipment_status.destroy
    respond_to do |format|
      format.html { redirect_to equipment_statuses_url, notice: 'Equipment status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipment_status
      @equipment_status = EquipmentStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def equipment_status_params
      params.require(:equipment_status).permit(:name, :desc, :group_id)
    end
end
