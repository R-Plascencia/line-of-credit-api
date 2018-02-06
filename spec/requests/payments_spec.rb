require 'rails_helper'

RSpec.describe "Payments", type: :request do
  let(:user) { FactoryBot.create(:user)}
  let(:credit_line) { FactoryBot.create(:credit_line, user_id: user.id) }
  let!(:payment) { FactoryBot.create(:payment, credit_line_id: credit_line.id) }
  let(:reg_headers) do
    { 'Accept': 'application/json' }
  end

  let(:params) do
    {
      :payment => {
        :amount => 100,
        :credit_line_id => credit_line.id
      }
    }
  end
  
  let(:new_params) do
    {
      :amount => 150,
      :credit_line_id => credit_line.id
    }
  end

  describe "GET #index" do

    context 'When authenticated' do
      before { get "/api/users/#{user.id}/credit_lines/#{credit_line.id}/payments", headers: auth_headers(user)}

      it "works!" do
        expect(response).to have_http_status :ok
      end

      it 'returns all the credit line payments' do
        expect(json_response.size).to eq 1
      end
    end

    context 'When not authenticated' do
      before { get "/api/users/#{user.id}/credit_lines/#{credit_line.id}/payments", headers: reg_headers}

      it "has 401 response (unauthorized)" do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'GET #show' do
    context 'When authenticated' do
      before { get "/api/users/#{user.id}/credit_lines/#{credit_line.id}/payments/#{payment.id}", headers: auth_headers(user)}

      it 'works!' do
        expect(response).to have_http_status :ok
      end

      it 'shows the correct payment' do
        expect(json_response[:id]).to eq payment.id
      end

      it 'shows a payment amount' do
        expect(json_response[:amount]).to eq payment.amount
      end

      it 'shows a new balance' do
        expect(json_response).to have_key :new_bal
      end

      it 'references a credit line' do
        expect(json_response).to have_key :credit_line
      end
    end

    context 'When not authenticated' do
      before { get "/api/users/#{user.id}/credit_lines/#{credit_line.id}/payments/#{payment.id}", headers: reg_headers}

      it 'has a 401 response (unauth)' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'POST #create' do
    context 'When authenticated' do
      before { post "/api/users/#{user.id}/credit_lines/#{credit_line.id}/payments/", params: params, headers: auth_headers(user)}

      it 'works! (created)' do
        expect(response).to have_http_status :created
      end

      it 'has correct amount' do
        expect(json_response[:amount]).to eq params[:payment][:amount]
      end

      it 'is attached to the right credit line' do
        expect(json_response[:credit_line][:id]).to eq payment.credit_line.id
      end

      it 'returns a new balance' do
        expect(json_response).to have_key :new_bal
      end
    end
  end

  describe 'PATCH #update' do
    context 'When authenticated' do
      before { patch "/api/users/#{user.id}/credit_lines/#{credit_line.id}/payments/#{payment.id}",params: new_params, headers: auth_headers(user)}

      it 'is forbidden' do
        expect(response).to have_http_status :forbidden
      end
    end

    context 'When not authenticated' do
      before { patch "/api/users/#{user.id}/credit_lines/#{credit_line.id}/payments/#{payment.id}",params: new_params, headers: reg_headers}

      it 'is unauthorized (401)' do 
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'When authenticated' do
      before { delete "/api/users/#{user.id}/credit_lines/#{credit_line.id}/payments/#{payment.id}", headers: auth_headers(user)}

      it 'works! (destroyed)' do
        expect(response).to have_http_status :no_content
      end
    end
    
    context 'When not authenticated' do
      before { patch "/api/users/#{user.id}/credit_lines/#{credit_line.id}/payments/#{payment.id}", headers: reg_headers}
      
      it 'is unauthorized (401)' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
