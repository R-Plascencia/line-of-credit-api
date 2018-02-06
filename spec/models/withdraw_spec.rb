require 'rails_helper'

RSpec.describe Withdrawal, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  subject{ described_class.new(:amount => 50, :credit_line_id => 1) }

  describe 'Validity' do
    it 'has attributes' do
      expect(Withdrawal.new).to_not be_valid
    end

    it 'has an amount' do
      expect(Withdrawal.new({ :credit_line_id => 1 })).to_not be_valid
    end

    it 'has an amount that is not null' do
      expect(Withdrawal.new({ :credit_line_id => 1, :amount => nil })).to_not be_valid
    end

    it 'has a credit line ID' do
      expect(Withdrawal.new({ :amount => 20 })).to_not be_valid
    end

    it 'has a credit line ID that is not null' do
      expect(Withdrawal.new({ :amount => 20, :credit_line_id => nil })).to_not be_valid
    end

    it 'has amount greater than 0' do
      expect(Withdrawal.new({ :amount => -1, :credit_line_id => 1 })).to_not be_valid
    end
  end

  describe 'Associations' do
    it { should belong_to(:credit_line) }
  end

end
