class EquipmentTracksController < ApplicationController
  before_action :set_equipment_track, only: [:show, :edit, :update, :destroy]

  # GET /equipment_tracks
  # GET /equipment_tracks.json
  def index
    @equipment_tracks = EquipmentTrack.all.paginate(page: params[:page])
  end

  # GET /equipment_tracks/1
  # GET /equipment_tracks/1.json
  def show
  end

  # GET /equipment_tracks/new
  def new
    @equipment_track = EquipmentTrack.new
  end

  # GET /equipment_tracks/1/edit
  def edit
  end

  # POST /equipment_tracks
  # POST /equipment_tracks.json
  def create
    @equipment_track = EquipmentTrack.new(equipment_track_params)

    respond_to do |format|
      if @equipment_track.save
        format.html { redirect_to @equipment_track, notice: 'Equipment track was successfully created.' }
        format.json { render :show, status: :created, location: @equipment_track }
      else
        format.html { render :new }
        format.json { render json: @equipment_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equipment_tracks/1
  # PATCH/PUT /equipment_tracks/1.json
  def update
    respond_to do |format|
      if @equipment_track.update(equipment_track_params)
        format.html { redirect_to @equipment_track, notice: 'Equipment track was successfully updated.' }
        format.json { render :show, status: :ok, location: @equipment_track }
      else
        format.html { render :edit }
        format.json { render json: @equipment_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipment_tracks/1
  # DELETE /equipment_tracks/1.json
  def destroy
    @equipment_track.destroy
    respond_to do |format|
      format.html { redirect_to equipment_tracks_url, notice: 'Equipment track was successfully destroyed.' }
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
        msg = FileHandler::Excel::EquipmentTrackHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def search
    super { |query|
      if params.has_key? "normal"
        query=EquipmentTrack.normal
      elsif params.has_key? "scrap"
        query=EquipmentTrack.scrap
      end

      query
    }
  end

  def download
    send_data(EquipmentTrack.download_to_xlsx,
              :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
              :filename => @model.pluralize+".xlsx")
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_equipment_track
    @equipment_track = EquipmentTrack.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def equipment_track_params
    params.require(:equipment_track).permit(:level, :name, :nr, :type, :asset_nr, :description, :product_id, :equipment_serial_id, :supplier, :status, :profit_center,
                                            :department, :project, :location, :ts_area_id, :position, :cap_date, :release_cycle, :next_release, :release_notice,
                                            :asset_bu_id, :remark, :is_top, :operate_instructor, :maintain_instructor, :asset_class, :inventory_user_id, :keeper,
                                            :nameplate_track, :ts_type, :ts_equipment_type,:inventory_result, :process_params, :maintain_plan, :machine_down,
                                            :big_maintain_plan, :instruction, :replacement_list, :equip_create_way, :rfid_nr)
  end
end
