require 'rails_helper'

RSpec.describe "UserToken", type: :request do
  describe "POST /user_token creates JWT" do
    let(:user) { FactoryBot.create(:user)}
    let(:auth_params) do
      # "{'auth': {'email': '#{user.email}', 'password': '#{user.password}'}}"
      {
        :auth => {
          :email => user.email,
          :password => user.password
        }
      }
    end

    let(:reg_headers) do
      { 'Accept': 'application/json' }
    end

    before do
      # puts auth_params
      post '/user_token', params: auth_params, headers: reg_headers 
    end

    it "works! (created)" do
      expect(response).to have_http_status(:created)
    end

  end
end
