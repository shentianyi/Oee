class BuMangersController < ApplicationController
  before_action :set_bu_manger, only: [:show, :edit, :update, :destroy]

  # GET /bu_mangers
  # GET /bu_mangers.json
  def index
    @bu_mangers = BuManger.all
  end

  # GET /bu_mangers/1
  # GET /bu_mangers/1.json
  def show
  end

  # GET /bu_mangers/new
  def new
    @bu_manger = BuManger.new
  end

  # GET /bu_mangers/1/edit
  def edit
  end

  # POST /bu_mangers
  # POST /bu_mangers.json
  def create
    @bu_manger = BuManger.new(bu_manger_params)

    respond_to do |format|
      if @bu_manger.save
        format.html { redirect_to @bu_manger, notice: 'Bu manger was successfully created.' }
        format.json { render :show, status: :created, location: @bu_manger }
      else
        format.html { render :new }
        format.json { render json: @bu_manger.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bu_mangers/1
  # PATCH/PUT /bu_mangers/1.json
  def update
    respond_to do |format|
      if @bu_manger.update(bu_manger_params)
        format.html { redirect_to @bu_manger, notice: 'Bu manger was successfully updated.' }
        format.json { render :show, status: :ok, location: @bu_manger }
      else
        format.html { render :edit }
        format.json { render json: @bu_manger.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bu_mangers/1
  # DELETE /bu_mangers/1.json
  def destroy
    @bu_manger.destroy
    respond_to do |format|
      format.html { redirect_to bu_mangers_url, notice: 'Bu manger was successfully destroyed.' }
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
        msg = FileHandler::Excel::BuMangerHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bu_manger
      @bu_manger = BuManger.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bu_manger_params
      params.require(:bu_manger).permit(:nr, :name, :finance_nr, :desc)
    end
end
