class WithdrawalsController < ApplicationController
  before_action :set_user
  before_action :set_credit_line
  before_action :set_withdrawal, only: [:show, :update, :destroy]

  # GET /users/:user_id/credit_lines/:credit_line_id/withdrawals
  def index
    render json: @credit_line.withdrawals
  end

  # GET /users/:user_id/credit_lines/:credit_line_id/withdrawals/:id
  def show
    render json: @withdrawal
  end

  # POST /users/:user_id/credit_lines/:credit_line_id/withdrawals
  def create
    @withdrawal = Withdrawal.new(withdrawal_params)
    @credit_line.principal_bal += @withdrawal.amount
    @withdrawal.new_bal = @credit_line.principal_bal

    if @withdrawal.save && @credit_line.save
      render json: @withdrawal, status: :created
    else
      render json: @withdrawal.errors, status: :unprocessable_entity
    end
  end

  # Withdrawals should not be able to be modified after they have been created. If an
  # account needs a withdrawal reversed, then a payment would be made in the amount needed
  #
  # PATCH/PUT /users/:user_id/credit_lines/:credit_line_id/withdrawals/:id
  def update
    # if @withdrawal.update(withdrawal_params)
    #   render json: @withdrawal
    # else
    #   render json: @withdrawal.errors, status: :unprocessable_entity
    # end
    render json: {status: 'error', code: 403, message: 'Withdrawals cannot be edited or otherwise tampered with after creation.'}

  end

  # DELETE /users/:user_id/credit_lines/:credit_line_id/withdrawals/:id
  def destroy
    @withdrawal.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_withdrawal
      @withdrawal = Withdrawal.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_credit_line
      @credit_line = CreditLine.find(params[:credit_line_id])
    end

    # Only allow a trusted parameter "white list" through.
    def withdrawal_params
      params.require(:withdrawal).permit(:credit_line_id, :amount, :new_bal)
    end
end
