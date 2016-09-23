class EquipmentReleasesController < ApplicationController
  before_action :set_equipment_release, only: [:show, :edit, :update, :destroy]

  # GET /equipment_releases
  # GET /equipment_releases.json
  def index
    @equipment_releases = EquipmentRelease.all
  end

  # GET /equipment_releases/1
  # GET /equipment_releases/1.json
  def show
  end

  # GET /equipment_releases/new
  def new
    @equipment_release = EquipmentRelease.new
  end

  # GET /equipment_releases/1/edit
  def edit
  end

  # POST /equipment_releases
  # POST /equipment_releases.json
  def create
    @equipment_release = EquipmentRelease.new(equipment_release_params)

    respond_to do |format|
      if @equipment_release.save
        format.html { redirect_to @equipment_release, notice: 'Equipment release was successfully created.' }
        format.json { render :show, status: :created, location: @equipment_release }
      else
        format.html { render :new }
        format.json { render json: @equipment_release.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equipment_releases/1
  # PATCH/PUT /equipment_releases/1.json
  def update
    respond_to do |format|
      if @equipment_release.update(equipment_release_params)
        format.html { redirect_to @equipment_release, notice: 'Equipment release was successfully updated.' }
        format.json { render :show, status: :ok, location: @equipment_release }
      else
        format.html { render :edit }
        format.json { render json: @equipment_release.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipment_releases/1
  # DELETE /equipment_releases/1.json
  def destroy
    @equipment_release.destroy
    respond_to do |format|
      format.html { redirect_to equipment_releases_url, notice: 'Equipment release was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipment_release
      @equipment_release = EquipmentRelease.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def equipment_release_params
      params.require(:equipment_release).permit(:equipment_track_id, :release_index, :release_time, :remark)
    end
end
