class WithdrawalsController < ApplicationController
  before_action :authenticate_user
  before_action :set_user
  before_action :set_credit_line
  before_action :set_withdrawal, only: [:show, :update, :destroy]

  include InterestHelper

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

    # Check if LOC is already maxed first
    if is_maxed?
      render status:402, json: {
        errors: 'Line of credit is maxed out. Please make a payment in order to continue use.'
      }
    else
      principal_bal = @credit_line.principal_bal
      new_principal = principal_bal + @withdrawal.amount
      credit_limit = @credit_line.credit_limit

      # Set interest on the previous balance before changing it
      interest = calculate_interest(@credit_line, principal_bal)

      # Now check if the withdrawal will put you over your limit
      if new_principal > credit_limit
        valid_amt = credit_limit - @credit_line.principal_bal

        render status:402, json:{
          errors: "Withdrawal surpasses credit limit. Can only withdraw $#{valid_amt.to_f.round(2)} or less."
        }
      else
        @credit_line.principal_bal = new_principal
        @withdrawal.new_bal = new_principal
        @credit_line.interest += interest

        # Before save set the maxed flag if we are now maxed out
        @credit_line.maxed = true if new_principal == credit_limit
    
        if @withdrawal.save && @credit_line.save
          render json: @withdrawal, status: :created
        else
          render json: @withdrawal.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  # Withdrawals should not be able to be modified after they have been created. If an
  # account needs a withdrawal reversed, then a payment would be made in the amount needed
  # PATCH/PUT /users/:user_id/credit_lines/:credit_line_id/withdrawals/:id
  def update
    # if @withdrawal.update(withdrawal_params)
    #   render json: @withdrawal
    # else
    #   render json: @withdrawal.errors, status: :unprocessable_entity
    # end
    render status:405, json: {
      errors: 'Withdrawals cannot be edited or otherwise tampered with after creation.'
    }
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

    def is_maxed?
      return @credit_line.maxed
    end

    # Only allow a trusted parameter "white list" through.
    def withdrawal_params
      params.require(:withdrawal).permit(:credit_line_id, :amount, :new_bal)
    end
end
