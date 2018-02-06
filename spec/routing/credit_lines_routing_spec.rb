require "rails_helper"

RSpec.describe CreditLinesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/users/1/credit_lines").to route_to("credit_lines#index", :user_id => "1")
    end


    it "routes to #show" do
      expect(:get => "/api/users/1/credit_lines/1").to route_to("credit_lines#show", :user_id => "1", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/api/users/1/credit_lines").to route_to("credit_lines#create", :user_id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/api/users/1/credit_lines/1").to route_to("credit_lines#update", :user_id => "1", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/api/users/1/credit_lines/1").to route_to("credit_lines#update", :user_id => "1", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/users/1/credit_lines/1").to route_to("credit_lines#destroy", :user_id => "1", :id => "1")
    end

  end
end
