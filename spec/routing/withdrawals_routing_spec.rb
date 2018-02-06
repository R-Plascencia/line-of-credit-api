require "rails_helper"

RSpec.describe WithdrawalsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/users/1/credit_lines/1/withdrawals").to route_to("withdrawals#index", :user_id => "1", :credit_line_id => "1")
    end


    it "routes to #show" do
      expect(:get => "/api/users/1/credit_lines/1/withdrawals/1").to route_to("withdrawals#show", :id => "1", :user_id => "1", :credit_line_id => "1")
    end


    it "routes to #create" do
      expect(:post => "/api/users/1/credit_lines/1/withdrawals").to route_to("withdrawals#create", :user_id => "1", :credit_line_id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/api/users/1/credit_lines/1/withdrawals/1").to route_to("withdrawals#update", :id => "1", :user_id => "1", :credit_line_id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/api/users/1/credit_lines/1/withdrawals/1").to route_to("withdrawals#update", :id => "1", :user_id => "1", :credit_line_id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/users/1/credit_lines/1/withdrawals/1").to route_to("withdrawals#destroy", :id => "1", :user_id => "1", :credit_line_id => "1")
    end

  end
end
