class Withdrawal < ApplicationRecord
  belongs_to :credit_line

  scope :newest_first, lambda { order('created_at DESC') }
end
