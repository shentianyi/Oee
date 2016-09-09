require 'will_paginate/array'

class DowntimeRecordsController < ApplicationController
  before_action :set_downtime_record, only: [:show, :edit, :update, :destroy]

  # GET /downtime_records
  # GET /downtime_records.json
  def index
    @downtime_records = DowntimeRecord.all.paginate(:page => params[:page]).order(machine_id: :asc, pd_von: :asc)
  end

  # GET /downtime_records/1
  # GET /downtime_records/1.json
  def show
  end

  # GET /downtime_records/new
  def new
    @downtime_record = DowntimeRecord.new
  end

  # GET /downtime_records/1/edit
  def edit
  end

  # POST /downtime_records
  # POST /downtime_records.json
  def create
    @downtime_record = DowntimeRecord.new(downtime_record_params)

    respond_to do |format|
      if @downtime_record.save
        format.html { redirect_to @downtime_record, notice: 'Downtime record was successfully created.' }
        format.json { render :show, status: :created, location: @downtime_record }
      else
        format.html { render :new }
        format.json { render json: @downtime_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /downtime_records/1
  # PATCH/PUT /downtime_records/1.json
  def update
    respond_to do |format|
      if @downtime_record.update(downtime_record_params)
        format.html { redirect_to @downtime_record, notice: 'Downtime record was successfully updated.' }
        format.json { render :show, status: :ok, location: @downtime_record }
      else
        format.html { render :edit }
        format.json { render json: @downtime_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /downtime_records/1
  # DELETE /downtime_records/1.json
  def destroy
    @downtime_record.destroy
    respond_to do |format|
      format.html { redirect_to downtime_records_url, notice: 'Downtime record was successfully destroyed.' }
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
        file=FileHandler::Csv::File.new(user_agent: request.user_agent.downcase, file_path: fd.full_path, file_name: file.original_filename)
        msg = FileHandler::Csv::DowntimeRecordHandler.import(file)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def search
    @machine_id = params[:machine_id]
    @machine_type_id = params[:machine_type_id]
    @time_start = params[:time_start].blank? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:time_start]
    @time_end = params[:time_end].blank? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:time_end]

    @dimensionality = 'machine'

    #check
    machine=Machine.find_by_id(params[:machine_id])
    machine_type=MachineType.find_by_id(params[:machine_type_id])

    #calc
    @calc_result = DowntimeRecord.generate_oee_data(@dimensionality, @time_start, @time_end, machine, machine_type).paginate(:page => params[:page])

    @downtime = DowntimeRecord.generate_downtime_data(@dimensionality, @time_start, @time_end, machine, machine_type)

    render :display
  end

  def display
    @calc_result=[].paginate(:page => params[:page])
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_downtime_record
    @downtime_record = DowntimeRecord.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def downtime_record_params
    params.require(:downtime_record).permit(:fors_werk, :fors_faufnr, :fors_faufpo, :fors_lnr, :machine_id, :pk_sch, :pk_datum, :pk_sch_std, :pk_sch_t, :craft_id, :pd_teb, :pd_stueck, :pd_auss_ruest, :pd_auss_prod, :pd_bemerk, :pd_user, :pd_erf_dat, :pd_von, :pd_bis, :downtime_code_id, :pd_std, :pd_laenge, :pd_rf, :is_naturl)
  end
end
