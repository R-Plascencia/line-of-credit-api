require "rails_helper"

RSpec.describe PaymentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/users/1/credit_lines/1/payments").to route_to("payments#index", :user_id => "1", :credit_line_id => "1")
    end


    it "routes to #show" do
      expect(:get => "/api/users/1/credit_lines/1/payments/1").to route_to("payments#show", :id => "1", :user_id => "1", :credit_line_id => "1")
    end


    it "routes to #create" do
      expect(:post => "/api/users/1/credit_lines/1/payments").to route_to("payments#create", :user_id => "1", :credit_line_id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/api/users/1/credit_lines/1/payments/1").to route_to("payments#update", :id => "1", :user_id => "1", :credit_line_id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/api/users/1/credit_lines/1/payments/1").to route_to("payments#update", :id => "1", :user_id => "1", :credit_line_id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/users/1/credit_lines/1/payments/1").to route_to("payments#destroy", :id => "1", :user_id => "1", :credit_line_id => "1")
    end

  end
end
