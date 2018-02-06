require "rails_helper"

RSpec.describe UserTokenController, type: :routing do
  describe "routing" do

    it "routes to #create" do
      expect(:post => "/user_token").to route_to("user_token#create")
    end

  end
end
