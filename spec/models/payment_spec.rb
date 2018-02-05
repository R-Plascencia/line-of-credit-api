require 'rails_helper'

RSpec.describe Payment, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  subject{ described_class.new(:amount => 50, :credit_line_id => 1) }

  describe 'Validity' do
    it 'has attributes' do
      expect(Payment.new).to_not be_valid
    end

    it 'has an amount' do
      expect(Payment.new({:credit_line_id => 1})).to_not be_valid
    end

    it 'has a credit line ID' do
      expect(Payment.new({ :amount => 20 })).to_not be_valid
    end

    it 'has amount greater than 0' do
      expect(Payment.new({ :amount => -1, :credit_line_id => 1})).to_not be_valid
    end
  end

end
