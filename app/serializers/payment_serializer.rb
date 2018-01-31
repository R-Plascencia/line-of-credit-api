class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :amount, :created_at, :new_bal
  has_one :credit_line
end
