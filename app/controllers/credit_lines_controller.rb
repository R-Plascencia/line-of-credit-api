class CreditLinesController < ApplicationController
  before_action :authenticate_user, except: [:index]
  before_action :set_user
  before_action :set_credit_line, only: [:show, :update, :destroy]

  # GET /users/:user_id/credit_lines
  def index
    render json: @user.credit_lines
  end

  # GET /users/:user_id/credit_lines/:id
  def show
    found = false
    current_user.credit_lines.each do |_cl|
      if _cl.id == @credit_line.id
        found = true
      end
    end
    
    if found
      render json: @credit_line
    else
      render_unauth
    end
  end

  # POST users/:user_id/credit_lines
  def create
    @credit_line = CreditLine.new(credit_line_params)

    if @credit_line.save
      #
      # Start the billing/interest period now. Goes for the amount of time in set() param
      #
      ApplyInterestCycleJob.set(wait: 30.days).perform_later(@credit_line)
      render json: @credit_line, status: :created
    else
      render json: @credit_line.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/:user_id/credit_lines/:id
  def update
    if owns_credit_line(current_user, params[:id])
      if @credit_line.update(credit_line_params)
        render json: @credit_line
      end
    else
      # render json: @credit_line.errors, status: :unprocessable_entity
      render_unauth
    end
  end

  # DELETE /users/:user_id/credit_lines/:id
  def destroy
    if current_user.id == params[:user_id].to_i
      @credit_line.destroy
    else
      render_unauth
    end
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
      params.permit(:user_id, :name, :credit_limit, :principal_bal, :apr, :maxed)
    end

    def owns_credit_line(user, credit_line_id)
      begin
        user_cl = user.credit_lines.find(credit_line_id)
      rescue => ex
        return false
      end

      return true
    end

    def render_unauth
      render status:401, json: { 
        message: 'Unauthorized'
      }
    end
end
