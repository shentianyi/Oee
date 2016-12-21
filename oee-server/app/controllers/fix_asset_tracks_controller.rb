class FixAssetTracksController < ApplicationController
  before_action :set_fix_asset_track, only: [:show, :edit, :update, :destroy]

  # GET /fix_asset_tracks
  # GET /fix_asset_tracks.json
  def index
    @fix_asset_tracks = FixAssetTrack.all.paginate(page: params[:page])
  end

  # GET /fix_asset_tracks/1
  # GET /fix_asset_tracks/1.json
  def show
  end

  # GET /fix_asset_tracks/new
  def new
    @fix_asset_track = FixAssetTrack.new
  end

  # GET /fix_asset_tracks/1/edit
  def edit
  end

  # POST /fix_asset_tracks
  # POST /fix_asset_tracks.json
  def create
    @fix_asset_track = FixAssetTrack.new(fix_asset_track_params)

    respond_to do |format|
      if @fix_asset_track.save
        format.html { redirect_to @fix_asset_track, notice: 'Fix asset track was successfully created.' }
        format.json { render :show, status: :created, location: @fix_asset_track }
      else
        format.html { render :new }
        format.json { render json: @fix_asset_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fix_asset_tracks/1
  # PATCH/PUT /fix_asset_tracks/1.json
  def update
    respond_to do |format|
      if @fix_asset_track.update(fix_asset_track_params)
        format.html { redirect_to @fix_asset_track, notice: 'Fix asset track was successfully updated.' }
        format.json { render :show, status: :ok, location: @fix_asset_track }
      else
        p @fix_asset_track.errors
        format.html { render :edit }
        format.json { render json: @fix_asset_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fix_asset_tracks/1
  # DELETE /fix_asset_tracks/1.json
  def destroy
    @fix_asset_track.destroy
    respond_to do |format|
      format.html { redirect_to fix_asset_tracks_url, notice: 'Fix asset track was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    if request.post?
      puts "--------------------------------------"
      msg = Message.new
      # begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::FixAssetTrackHandler.import(fd)
      # rescue => e
      #   msg.content = e.message
      # end
      render json: msg
    end
  end

  def search
    to_do_query=FixAssetTrack.all
    super{|query|
      to_do_query=to_do_query.to_do_list
    }
    to_do_query
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fix_asset_track
      @fix_asset_track = FixAssetTrack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fix_asset_track_params
      params.require(:fix_asset_track).permit(:info_receive_date, :apply_id, :description, :qty, :price, :proposer, :procurment_id, :procurment_date,
                                              :supplier, :project, :completed_id, :is_add_equipment, :equipment_nr, :is_add_fix_asset, :nr, :status,
                                              :remark, :equipment_track_id, :processing_id, :equip_create_way)
    end
end
