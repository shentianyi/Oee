class CapexesController < ApplicationController
  before_action :set_capex, only: [:show, :edit, :update, :destroy]

  # GET /capexes
  # GET /capexes.json
  def index
    @capexes = Capex.all
  end

  # GET /capexes/1
  # GET /capexes/1.json
  def show
  end

  # GET /capexes/new
  def new
    @capex = Capex.new()
    1.times { @capex.budgets.build }
  end

  # GET /capexes/1/edit
  def edit
  end

  # POST /capexes
  # POST /capexes.json
  def create
    @capex = Capex.new(capex_params)

    respond_to do |format|
      if @capex.save
        format.html { redirect_to @capex, notice: 'Capex was successfully created.' }
        format.json { render :show, status: :created, location: @capex }
      else
        format.html { render :new }
        format.json { render json: @capex.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /capexes/1
  # PATCH/PUT /capexes/1.json
  def update
    respond_to do |format|
      if @capex.update(capex_params)
        format.html { redirect_to @capex, notice: 'Capex was successfully updated.' }
        format.json { render :show, status: :ok, location: @capex }
      else
        format.html { render :edit }
        format.json { render json: @capex.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /capexes/1
  # DELETE /capexes/1.json
  def destroy
    @capex.destroy
    respond_to do |format|
      format.html { redirect_to capexes_url, notice: 'Capex was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_capex
    @capex = Capex.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def capex_params
    params.require(:capex).permit(:project, :bu_code, :desc,
                                  budgets_attributes: [
                                      :code, :type, :desc, :_destroy, :id,
                                      budget_items_attributes: [:qty, :unit_price, :total_price, :id, :_destroy],
                                      pam_lists_attributes: [:nr, :cost, :remained, :is_final_approved, :in_process, :approved, :budget_not_applied, :id, :_destroy,
                                                             pam_item_attributes: [
                                                                 :pa_no, :description, :qty, :total_cost, :applicant, :applicant_date,
                                                                 :supplier, :sap_no, :arrive_date, :final_release, :id, :_destroy
                                                             ]
                                      ]
                                  ]
    )
  end
end
