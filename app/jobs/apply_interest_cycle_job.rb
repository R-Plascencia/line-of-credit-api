class ApplyInterestCycleJob < ApplicationJob
  queue_as :default

  include InterestHelper

  # Performs end of billing cycle interest accrual. Calculates interest based on principal
  # bal and time since last balance change, adds it to principal balance, then resets interest
  # to start new period. 
  #
  # Enqueues next job to run at end to continue cycle
  #
  def perform(loc_obj)
    puts ''
    puts "===== End of Billing Cycle: Adding Interest Accrued to LoC ID #{loc_obj.id} ====="
    puts ''
    new_bal = loc_obj.principal_bal
    interest = calculate_interest(loc_obj, loc_obj.principal_bal)

    loc_obj.interest += interest
    new_bal = loc_obj.principal_bal + interest
    loc_obj.principal_bal = new_bal.round(2)
    loc_obj.interest = 0.0
    loc_obj.save

    ApplyInterestCycleJob.set(wait: 4.minutes).perform_later(loc_obj)
  end
end
