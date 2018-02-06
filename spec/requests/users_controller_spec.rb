require 'rails_helper'

RSpec.describe "UsersControllers", type: :request do

  describe "GET #index" do
    let!(:users) { FactoryBot.create_list(:user, 10) }

    before { get '/api/users/' }

    it 'works!' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all users' do
      expect(json_response.size).to eq(10)
    end
  end
end
