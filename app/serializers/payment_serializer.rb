class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :amount
  has_one :credit_line
end
