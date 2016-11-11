class PamListsController < ApplicationController
  before_action :set_pam_list, only: [:show, :edit, :update, :destroy]

  # GET /pam_lists
  # GET /pam_lists.json
  def index
    @pam_lists = PamList.all
  end

  # GET /pam_lists/1
  # GET /pam_lists/1.json
  def show
  end

  # GET /pam_lists/new
  def new
    @pam_list = PamList.new
  end

  # GET /pam_lists/1/edit
  def edit
  end

  # POST /pam_lists
  # POST /pam_lists.json
  def create
    @pam_list = PamList.new(pam_list_params)

    respond_to do |format|
      if @pam_list.save
        format.html { redirect_to @pam_list, notice: 'Pam list was successfully created.' }
        format.json { render :show, status: :created, location: @pam_list }
      else
        format.html { render :new }
        format.json { render json: @pam_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pam_lists/1
  # PATCH/PUT /pam_lists/1.json
  def update
    respond_to do |format|
      if @pam_list.update(pam_list_params)
        format.html { redirect_to @pam_list, notice: 'Pam list was successfully updated.' }
        format.json { render :show, status: :ok, location: @pam_list }
      else
        format.html { render :edit }
        format.json { render json: @pam_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pam_lists/1
  # DELETE /pam_lists/1.json
  def destroy
    @pam_list.destroy
    respond_to do |format|
      format.html { redirect_to pam_lists_url, notice: 'Pam list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pam_list
      @pam_list = PamList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pam_list_params
      params.require(:pam_list).permit(:nr, :cost, :remained, :is_final_approved, :in_process, :approved, :budget_not_applied, :budget_id)
    end
end
