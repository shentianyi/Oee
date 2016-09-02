class WorkShiftsController < ApplicationController
  before_action :set_work_shift, only: [:show, :edit, :update, :destroy]

  # GET /work_shifts
  # GET /work_shifts.json
  def index
    @work_shifts = WorkShift.all
  end

  # GET /work_shifts/1
  # GET /work_shifts/1.json
  def show
  end

  # GET /work_shifts/new
  def new
    @work_shift = WorkShift.new
  end

  # GET /work_shifts/1/edit
  def edit
  end

  # POST /work_shifts
  # POST /work_shifts.json
  def create
    @work_shift = WorkShift.new(work_shift_params)

    respond_to do |format|
      if @work_shift.save
        format.html { redirect_to @work_shift, notice: 'Work shift was successfully created.' }
        format.json { render :show, status: :created, location: @work_shift }
      else
        format.html { render :new }
        format.json { render json: @work_shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /work_shifts/1
  # PATCH/PUT /work_shifts/1.json
  def update
    respond_to do |format|
      if @work_shift.update(work_shift_params)
        format.html { redirect_to @work_shift, notice: 'Work shift was successfully updated.' }
        format.json { render :show, status: :ok, location: @work_shift }
      else
        format.html { render :edit }
        format.json { render json: @work_shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_shifts/1
  # DELETE /work_shifts/1.json
  def destroy
    @work_shift.destroy
    respond_to do |format|
      format.html { redirect_to work_shifts_url, notice: 'Work shift was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_shift
      @work_shift = WorkShift.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_shift_params
      params.require(:work_shift).permit(:nr, :name, :start_time, :end_time)
    end
end
