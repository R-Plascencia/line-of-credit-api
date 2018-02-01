module InterestHelper
    # Interest formula
    def interest_accrued(bal, apr, delta_days)
        (bal * apr / 365 * delta_days).round(2)
    end

    # Test using minutes instead of days. REVERT BEFORE SUBMIT
    def get_time_diff(ref_time)
        ((Time.now.utc - ref_time)/60).to_i
    end

    # Get difference in days between now and last activity (withdrawal, pmt, created_at)
    # def get_time_diff(ref_time)
    #     ((Time.now.utc - ref_time)/86400).to_i
    # end

    # Calculate the interest by taking into account the last activity and running interest
    # calculation on last principal balance and days in between
    def calculate_interest(loc_obj, principal_bal)
        recent_wdraw = loc_obj.withdrawals.newest_first.first
        recent_wdraw = recent_wdraw.created_at unless recent_wdraw.nil?
        recent_pmt = loc_obj.payments.newest_first.first
        recent_pmt = recent_pmt.created_at unless recent_pmt.nil?

        if recent_pmt.nil? && recent_wdraw.nil?
            start_time = loc_obj.created_at
            diff = get_time_diff(start_time)
            interest = interest_accrued(principal_bal, loc_obj.apr, diff)
        elsif !recent_pmt.nil? && recent_wdraw.nil?
            diff = get_time_diff(recent_pmt)
            interest = interest_accrued(principal_bal, loc_obj.apr, diff)
        elsif !recent_wdraw.nil? && recent_pmt.nil?
            diff = get_time_diff(recent_wdraw)
            interest = interest_accrued(principal_bal, loc_obj.apr, diff)
        elsif recent_pmt > recent_wdraw
            diff = get_time_diff(recent_pmt)
            interest = interest_accrued(principal_bal, loc_obj.apr, diff)
        else
            diff = get_time_diff(recent_wdraw)
            interest = interest_accrued(principal_bal, loc_obj.apr, diff)
        end

        return interest
    end
end
    