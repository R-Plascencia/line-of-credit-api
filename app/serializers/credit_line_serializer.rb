class CreditLineSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :credit_limit, :principal_bal, :apr, :maxed, :name
end
