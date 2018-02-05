require 'rails_helper'

RSpec.describe CreditLine, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  
  # Valid subject
  subject{ described_class.new(:name => 'Valid', :apr => 0.25, :credit_limit => 500, :user_id => 1) }

  describe 'Validity' do
    it 'has attributes' do
      expect(CreditLine.new).to_not be_valid
    end
  
    it "has a name" do
      expect(CreditLine.new({
        :credit_limit => 500,
        :apr => 0.25
      })).to_not be_valid
    end
  
    it "has an APR" do
      expect(CreditLine.new({
        :credit_limit => 500,
        :name => 'No APR test'
      })).to_not be_valid
    end
  
    it "has a Credit Limit" do
      expect(CreditLine.new({
        :apr => 0.63,
        :name => 'No cred limit test'
      })).to_not be_valid
    end
  
    it "has a user ID" do
      expect(CreditLine.new({
        :apr => 0.500,
        :name => 'No cred limit test',
        :credit_limit => 600
      })).to_not be_valid
    end
  
    it "is valid when all attributes are valid" do
      expect(subject).to be_valid
    end
  end

  describe 'Defaults' do
    it 'defaults principal balance to 0' do
      expect(subject.principal_bal).to eq(0)
    end

    it 'defaults maxed to false' do
      expect(subject.maxed).to be false
    end

    it 'defaults empty list for withdrawals' do
      expect(subject.withdrawals).to eq([])
    end

    it 'defaults empty list for payments' do
      expect(subject.payments).to eq([])
    end
  end
  
end
