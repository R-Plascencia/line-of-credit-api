class CreditLinesController < ApplicationController
  before_action :set_credit_line, only: [:show, :update, :destroy]

  # GET /credit_lines
  def index
    @credit_lines = CreditLine.all

    render json: @credit_lines
  end

  # GET /credit_lines/1
  def show
    render json: @credit_line
  end

  # POST /credit_lines
  def create
    @credit_line = CreditLine.new(credit_line_params)

    if @credit_line.save
      render json: @credit_line, status: :created, location: @credit_line
    else
      render json: @credit_line.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /credit_lines/1
  def update
    if @credit_line.update(credit_line_params)
      render json: @credit_line
    else
      render json: @credit_line.errors, status: :unprocessable_entity
    end
  end

  # DELETE /credit_lines/1
  def destroy
    @credit_line.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit_line
      @credit_line = CreditLine.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def credit_line_params
      params.require(:credit_line).permit(:user_id, :name, :credit_limit, :principal_bal, :apr, :maxed)
    end
end
