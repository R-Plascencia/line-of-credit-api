class CreditLinesController < ApplicationController
  before_action :set_user
  before_action :set_credit_line, only: [:show, :update, :destroy]

  # GET /users/:user_id/credit_lines
  def index
    render json: @user.credit_lines
  end

  # GET /users/:user_id/credit_lines/:id
  def show
    render json: @credit_line
  end

  # POST users/:user_id/credit_lines
  def create
    @credit_line = CreditLine.new(credit_line_params)

    if @credit_line.save
      ApplyInterestCycleJob.set(wait: 5.minutes).perform_later(@credit_line)
      render json: @credit_line, status: :created
    else
      render json: @credit_line.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/:user_id/credit_lines/:id
  def update
    if @credit_line.update(credit_line_params)
      render json: @credit_line
    else
      render json: @credit_line.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/:user_id/credit_lines/:id
  def destroy
    @credit_line.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit_line
      @credit_line = CreditLine.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    # Only allow a trusted parameter "white list" through.
    def credit_line_params
      params.require(:credit_line).permit(:user_id, :name, :credit_limit, :principal_bal, :apr, :maxed)
    end
end
