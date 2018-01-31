class PaymentsController < ApplicationController
  before_action :set_user
  before_action :set_credit_line
  before_action :set_payment, only: [:show, :update, :destroy]

  # GET /users/:user_id/credit_lines/:credit_line_id/payments
  def index
    render json: @credit_line.payments
  end

  # GET /users/:user_id/credit_lines/:credit_line_id/payments/:id
  def show
    render json: @payment
  end

  # POST /users/:user_id/credit_lines/:credit_line_id/payments
  def create
    @payment = Payment.new(payment_params)

    if @payment.save
      render json: @payment, status: :created
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # Payments should not be able to be modified after they have been created
  #
  # PATCH/PUT /users/:user_id/credit_lines/:credit_line_id/payments/:id
  def update
    # if @payment.update(payment_params)
    #   render json: @payment
    # else
    #   render json: @payment.errors, status: :unprocessable_entity
    # end
    render json: {status: 'error', code: 403, message: 'Payments cannot be edited or otherwise tampered with after creation.'}
  end

  # DESTROY is ok, as in real life we might just want to store past payments for 
  # set amount of time then rid of it
  #
  # DELETE /users/:user_id/credit_lines/:credit_line_id/payments/:id
  def destroy
    @payment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_credit_line
      @credit_line = CreditLine.find(params[:credit_line_id])
    end

    # Only allow a trusted parameter "white list" through.
    def payment_params
      params.require(:payment).permit(:amount, :credit_line_id)
    end
end
