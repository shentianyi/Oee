class DowntimeTypesController < ApplicationController
  before_action :set_downtime_type, only: [:show, :edit, :update, :destroy]

  # GET /downtime_types
  # GET /downtime_types.json
  def index
    @downtime_types = DowntimeType.all.paginate(:page=> params[:page]).order(nr: :asc)
  end

  # GET /downtime_types/1
  # GET /downtime_types/1.json
  def show
  end

  # GET /downtime_types/new
  def new
    @downtime_type = DowntimeType.new
  end

  # GET /downtime_types/1/edit
  def edit
  end

  # POST /downtime_types
  # POST /downtime_types.json
  def create
    @downtime_type = DowntimeType.new(downtime_type_params)

    respond_to do |format|
      if @downtime_type.save
        format.html { redirect_to @downtime_type, notice: 'Downtime type was successfully created.' }
        format.json { render :show, status: :created, location: @downtime_type }
      else
        format.html { render :new }
        format.json { render json: @downtime_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /downtime_types/1
  # PATCH/PUT /downtime_types/1.json
  def update
    respond_to do |format|
      if @downtime_type.update(downtime_type_params)
        format.html { redirect_to @downtime_type, notice: 'Downtime type was successfully updated.' }
        format.json { render :show, status: :ok, location: @downtime_type }
      else
        format.html { render :edit }
        format.json { render json: @downtime_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /downtime_types/1
  # DELETE /downtime_types/1.json
  def destroy
    @downtime_type.destroy
    respond_to do |format|
      format.html { redirect_to downtime_types_url, notice: 'Downtime type was successfully destroyed.' }
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
        msg = FileHandler::Excel::DowntimeTypeHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_downtime_type
      @downtime_type = DowntimeType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def downtime_type_params
      params.require(:downtime_type).permit(:nr, :name, :description)
    end
end
