require 'rails_helper'

RSpec.describe "CreditLinesControllers", type: :request do

  # 'Content-Type': 'application/json'
  let(:user) { FactoryBot.create(:user)}
  let(:credit_line) { FactoryBot.create(:credit_line, user_id: user.id)}

  let(:params) do
    {
      :credit_limit => 1000,
      :apr => 0.25,
      :name => 'Valid line' ,
      :user_id => user.id
    }
  end

  let(:new_params) do
    {
      :credit_limit => 2000,
      :apr => 0.35,
      :name => 'Valid line update' ,
      :user_id => user.id
    }
  end

  let(:reg_headers) do
    { 'Accept': 'application/json' }
  end
  
  describe "GET #index" do
    before { get "/api/users/#{user.id}/credit_lines/", headers: reg_headers }

    it 'works!' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a list' do
      expect(json_response).to be_empty
    end
  end

  describe 'POST #create' do

    context 'When authenticated' do
      before { post "/api/users/#{user.id}/credit_lines/", params: params, headers: auth_headers(user) }

      it 'works! (created successfully)' do
        expect(response).to have_http_status(:created)
      end
  
      it 'has correct credit_limit' do
        expect(json_response[:credit_limit]).to eq params[:credit_limit]
      end
  
      it 'has correct APR' do
        expect(json_response[:apr]).to eq params[:apr]
      end
  
      it 'has correct name' do
        expect(json_response[:name]).to eq params[:name]
      end
  
      it 'has correct user ID' do
        expect(json_response[:user_id]).to eq params[:user_id]
      end
    end

    context 'When not authenticated' do
      before { post "/api/users/#{user.id}/credit_lines/", params: params, headers: reg_headers }

      it 'has 401 response (unauthorized)' do
        expect(response).to have_http_status(:unauthorized)
      end
    end 
  end

  describe 'GET #show' do

    context 'When authenticated' do
      before { get "/api/users/#{user.id}/credit_lines/#{credit_line.id}", headers: auth_headers(user) }

      it 'works!' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'When not authenticated' do
      before { get "/api/users/#{user.id}/credit_lines/#{credit_line.id}", headers: reg_headers }

      it 'has 401 response (unauthorized)' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #update' do

    context 'When authenticated' do
      before do patch "/api/users/#{user.id}/credit_lines/#{credit_line.id}", 
        params:  new_params,
        headers: auth_headers(user) 
      end

      it 'works!' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates name' do
        expect(json_response[:name]).to eq new_params[:name]
      end

      it 'updates APR' do
        expect(json_response[:apr]).to eq new_params[:apr]
      end

      it 'updates credit limit' do
        expect(json_response[:credit_limit]).to eq new_params[:credit_limit]
      end
    end

    context 'When not authenticated' do
      before do patch "/api/users/#{user.id}/credit_lines/#{credit_line.id}", 
        params:  new_params,
        headers: reg_headers 
      end

      it 'has 401 response (unauthorized)' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #destroy' do

    context 'When authenticated' do
      before { delete "/api/users/#{user.id}/credit_lines/#{credit_line.id}", headers: auth_headers(user) }

      it 'works! (destroyed)' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'When not authenitcated' do
      before { delete "/api/users/#{user.id}/credit_lines/#{credit_line.id}", headers: reg_headers }

      it 'has 401 response (unauthorized)' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end
