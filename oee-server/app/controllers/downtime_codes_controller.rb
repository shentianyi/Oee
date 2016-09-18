class DowntimeCodesController < ApplicationController
  before_action :set_downtime_code, only: [:show, :edit, :update, :destroy]

  # GET /downtime_codes
  # GET /downtime_codes.json
  def index
    @downtime_codes = DowntimeCode.all.paginate(:page=> params[:page]).order(downtime_type_id: :asc)
  end

  # GET /downtime_codes/1
  # GET /downtime_codes/1.json
  def show
  end

  # GET /downtime_codes/new
  def new
    @downtime_code = DowntimeCode.new
  end

  # GET /downtime_codes/1/edit
  def edit
  end

  # POST /downtime_codes
  # POST /downtime_codes.json
  def create
    @downtime_code = DowntimeCode.new(downtime_code_params)

    respond_to do |format|
      if @downtime_code.save
        format.html { redirect_to downtime_codes_url, notice: '成功添加.' }
        format.json { render :show, status: :created, location: @downtime_code }
      else
        format.html { render :new }
        format.json { render json: @downtime_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /downtime_codes/1
  # PATCH/PUT /downtime_codes/1.json
  def update
    respond_to do |format|
      if @downtime_code.update(downtime_code_params)
        format.html { redirect_to downtime_codes_url, notice: '成功更新.' }
        format.json { render :show, status: :ok, location: @downtime_code }
      else
        format.html { render :edit }
        format.json { render json: @downtime_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /downtime_codes/1
  # DELETE /downtime_codes/1.json
  def destroy
    @downtime_code.destroy
    respond_to do |format|
      format.html { redirect_to downtime_codes_url, notice: '成功删除.' }
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
        msg = FileHandler::Excel::DowntimeCodeHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_downtime_code
      @downtime_code = DowntimeCode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def downtime_code_params
      params.require(:downtime_code).permit(:nr, :downtime_type_id, :description)
    end
end
