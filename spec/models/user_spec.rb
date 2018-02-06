require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  subject{ described_class.new(:first_name => 'Valid', :email => 'test@rspec.com', :password => 'abc123') }

  describe 'Validity' do
    it 'has attributes' do
      expect(User.new).to_not be_valid
    end

    it 'has email' do
      expect(User.new({
        :password => 'abc123'
      })).to_not be_valid
    end

    it 'has password' do
      expect(User.new({
        :email => 'abc@test.com'
      })).to_not be_valid
    end

    it 'is valid with all required attributes' do
      expect(subject).to be_valid
    end
  end

  describe 'Defaults' do
    it 'defaults email to blank upon new instance' do
      expect(User.new.email).to eq ''
    end

    it 'defaults user credit lines to empty list' do
      expect(subject.credit_lines).to eq []
    end
  end

  describe 'Associations' do
    it { should have_many(:credit_lines) }
  end

end
