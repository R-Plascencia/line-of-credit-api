class WithdrawalSerializer < ActiveModel::Serializer
  attributes :id, :amount, :new_bal, :credit_line_id, :created_at
  has_one :credit_line
end
