class Payment < ApplicationRecord
  belongs_to :credit_line

  validates_presence_of :amount, :credit_line
  validates :amount, :numericality => { :greater_than_or_equal_to => 1 }

  scope :newest_first, lambda { order('created_at DESC') }
end
