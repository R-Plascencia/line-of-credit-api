require 'rails_helper'

RSpec.describe "UsersControllers", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let(:reg_headers) do
    { 'Accept': 'application/json' }
  end

  let(:params) do
    {
      :first_name => 'Mr.Test',
      :email => 'testme@test.com',
      :password => 'abc123'
    }
  end

  let(:new_params) do
    {
      :first_name => 'Dr.Test',
      :email => 'testme1@test.com',
      :password => 'abc1234'
    }
  end


  describe "GET #index" do
    let!(:users) { FactoryBot.create_list(:user, 10) }

    before { get '/api/users/' }

    it 'works!' do
      expect(response).to have_http_status :ok
    end

    it 'returns all users' do
      expect(json_response.size).to eq 11 # The list of 10 (line 10) + 1 (line 4) = 11
    end
  end

  describe 'GET #show' do
    context 'When authenticated' do
      before { get "/api/users/#{user.id}", headers: auth_headers(user) }

      it 'shows the correct user' do
        expect(json_response[:id]).to eq user.id
      end

      it 'shows an email' do
        expect(json_response).to have_key :email
      end

      it "shows user's credit lines" do
        expect(json_response).to have_key :credit_lines
      end
    end

    context 'When not authenticated' do
      before { get "/api/users/#{user.id}", headers: reg_headers }

      it 'is unauthorized (401)' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'POST #create' do
    before { post "/api/users/", params: params, headers: reg_headers }

    it 'works! (created)' do
      expect(response).to have_http_status :created
    end

    it 'has correct email' do
      expect(json_response[:email]).to eq params[:email]
    end
  end

  describe 'PATCH #update' do
    context 'When authenticated' do
      before { patch "/api/users/#{user.id}", params: new_params, headers: auth_headers(user) }

      it 'works!' do
        expect(response).to have_http_status :ok
      end

      it 'updates correct user' do
        expect(json_response[:id]).to eq user.id
      end

      it 'updates name correctly' do
        expect(json_response[:first_name]).to eq new_params[:first_name]
      end

      it 'updates email correctly' do
        expect(json_response[:email]).to eq new_params[:email]
      end

      it 'updates password correctly' do
        expect(json_response[:password]).to eq new_params[:password]
      end
    end

    context 'When not authenticated' do
      before { patch "/api/users/#{user.id}", params: new_params, headers: reg_headers }

      it 'does not work' do
        expect(response).to_not have_http_status :ok
      end
    end
  end

  describe 'POST #destroy' do
    context 'When authenticated' do
      before { delete "/api/users/#{user.id}", headers: auth_headers(user) }

      it 'works! (destroyed)' do
        expect(response).to have_http_status :no_content
      end
    end

    context 'When not authenticated' do
      before { delete "/api/users/#{user.id}", headers: reg_headers }

      it 'is unauthorized (401)' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
