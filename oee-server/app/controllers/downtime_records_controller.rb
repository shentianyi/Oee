require 'will_paginate/array'

class DowntimeRecordsController < ApplicationController
  before_action :set_downtime_record, only: [:show, :edit, :update, :destroy]
  before_action :downtime_record_params, only: [:search]
  # skip_before_action :downtime_record_params

  # GET /downtime_records
  # GET /downtime_records.json
  def index
    @downtime_records = DowntimeRecord.all.paginate(:page => params[:page]).order(pd_von: :asc, machine_id: :asc)
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
        format.html { redirect_to downtime_records_url, notice: '成功添加.' }
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
        format.html { redirect_to downtime_records_url, notice: '成功更新.' }
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
      format.html { redirect_to downtime_records_url, notice: '成功删除.' }
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

  def display
    if request.post?
      params[:downtime_records]= {} if params[:downtime_records].blank?

      @machine_id = params[:downtime_records][:machine_id]
      @machine_type_id = params[:downtime_records][:machine_type_id]
      @time_start = params[:downtime_records][:time_start].blank? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:downtime_records][:time_start]
      @time_end = params[:downtime_records][:time_end].blank? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:downtime_records][:time_end]
      @dimensionality = params[:downtime_records][:dimensionality].blank? ? DimensionalityEnum::MACHINE : params[:downtime_records][:dimensionality].to_i
      @is_daily = params[:downtime_records][:is_daily]=='true' ? true : false

      #check
      machine=Machine.find_by_id(params[:downtime_records][:machine_id])
      machine_type=MachineType.find_by_id(params[:downtime_records][:machine_type_id])

      #calc
      @calc_result = DowntimeRecord.generate_oee_data(@time_start, @time_end, machine, machine_type, @dimensionality, @is_daily)

      @bu_calc_result = DowntimeRecord.generate_bu_oee_data(@time_start, @time_end, machine, machine_type, @dimensionality)

      @downtime = DowntimeRecord.generate_downtime_data(@time_start, @time_end, machine, machine_type, @dimensionality, @is_daily)

      @bu_downtime = DowntimeRecord.generate_bu_downtime_data(@time_start, @time_end, machine, machine_type, @dimensionality)

      #停机前 5大
      @downtime_record_limit = DowntimeRecord.generate_downtime_record_limit(@time_start, @time_end, machine, machine_type, @dimensionality)


      render :json => {result: true, oee: @calc_result, downtime_code: @downtime, bu_oee: @bu_calc_result, bu_downtime: @bu_downtime, limit: @downtime_record_limit}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_downtime_record
    @downtime_record = DowntimeRecord.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def downtime_record_params
    params.require(:downtime_record).permit(:fors_werk, :fors_faufnr, :fors_faufpo, :fors_lnr, :machine_id, :pk_sch, :pk_datum, :pk_sch_std,
                                            :pk_sch_t, :craft_id, :pd_teb, :pd_stueck, :pd_auss_ruest, :pd_auss_prod, :pd_bemerk, :pd_user,
                                            :pd_erf_dat, :pd_von, :pd_bis, :downtime_code_id, :pd_std, :pd_laenge, :pd_rf, :is_naturl,
                                            :pd_bemerk_fuzzy, :pk_datum_start, :pk_datum_end, :page)
  end
end
