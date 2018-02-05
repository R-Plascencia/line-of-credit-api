class CreditLine < ApplicationRecord
    belongs_to :user
    has_many :payments
    has_many :withdrawals

    validates_presence_of :name, :credit_limit, :apr

    scope :has_outstanding_principal, lambda { where('principal_bal > 0') }
    scope :sorted, lambda { order('principal_bal ASC') }
    scope :newest_first, lambda { order('created_at DESC') }
    scope :hi_interest_first, lambda { order('interest DESC')}
    scope :not_maxed, lambda { where(:maxed => false) }
    scope :maxed, lambda { where(:maxed => true) }
    scope :search, lambda {|q| 
        where(['name LIKE ?', "%#{q}%"])
    }
end
