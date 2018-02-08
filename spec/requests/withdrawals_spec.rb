require 'rails_helper'

RSpec.describe "Withdrawals", type: :request do
  let(:user) { FactoryBot.create(:user)}
  let(:credit_line) { FactoryBot.create(:credit_line, user_id: user.id) }
  let!(:withdrawal) { FactoryBot.create(:withdrawal, credit_line_id: credit_line.id) }
  let(:cl_prev_bal) { credit_line.principal_bal }
  let(:reg_headers) do
    { 'Accept': 'application/json' }
  end

  let(:params) do
    {
      :amount => 100,
      :credit_line_id => credit_line.id
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
      before { get "/api/users/#{user.id}/credit_lines/#{credit_line.id}/withdrawals", headers: auth_headers(user)}

      it 'works!' do
        expect(response).to have_http_status :ok
      end

      it "return all the credit line's withdrawals" do
        expect(json_response.size).to eq 1
      end
    end

    context 'When not authenticated' do
      before { get "/api/users/#{user.id}/credit_lines/#{credit_line.id}/withdrawals", headers: reg_headers}

      it 'has response 401 (unauthorized)' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'GET #show' do

    context 'When authenticated' do
      before { get "/api/users/#{user.id}/credit_lines/#{credit_line.id}/withdrawals/#{withdrawal.id}", headers: auth_headers(user)}

      it 'works!' do
        expect(response).to have_http_status :ok
      end

      it 'shows an amount' do
        expect(json_response).to have_key :amount
      end

      it 'shows a new balance' do
        expect(json_response).to have_key :new_bal
      end

      it 'references a credit line' do
        expect(json_response).to have_key :credit_line
      end
    end

    context 'When not authenticated' do
      before { get "/api/users/#{user.id}/credit_lines/#{credit_line.id}/withdrawals/#{withdrawal.id}", headers: reg_headers}

      it 'has 401 response (unauthorized)' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'POST #create' do

    context 'When authenticated' do
      before { post "/api/users/#{user.id}/credit_lines/#{credit_line.id}/withdrawals/", params: params, headers: auth_headers(user) }

      it 'works! (created)' do
        expect(response).to have_http_status :created
      end

      it 'has an amount' do
        expect(json_response).to have_key :amount
      end

      it 'has correct amount' do
        expect(json_response[:amount]).to eq params[:amount]
      end

      it 'references correct credit line' do
        expect(json_response[:credit_line_id]).to eq params[:credit_line_id]
      end

      it 'returns a new balance' do
        expect(json_response).to have_key :new_bal
      end

      it 'has correct new balance' do
        expect(json_response[:new_bal]).to eq(credit_line.principal_bal + params[:amount])
      end

      it 'affects credit line principal' do
        line = CreditLine.find(credit_line.id)
        expect(line.principal_bal).to eq (cl_prev_bal + params[:amount])
      end
    end

    context 'When not authenticated' do 
      before { post "/api/users/#{user.id}/credit_lines/#{credit_line.id}/withdrawals/", headers: reg_headers}

      it 'has 401 response (unauthorized)' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'PATCH/PUT #update' do

    context 'When authenticated' do
      before { patch "/api/users/#{user.id}/credit_lines/#{credit_line.id}/withdrawals/#{withdrawal.id}", params: new_params, headers: auth_headers(user)}

      it 'is not allowed' do
        expect(response).to have_http_status :method_not_allowed
      end
    end

    context 'When not authenticated' do
      before { patch "/api/users/#{user.id}/credit_lines/#{credit_line.id}/withdrawals/#{withdrawal.id}", params: new_params, headers: reg_headers}

      it 'has 401 response (not allowed)' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'POST #destroy' do

    context 'When authenticated' do
      before { delete "/api/users/#{user.id}/credit_lines/#{credit_line.id}/withdrawals/#{withdrawal.id}", headers: auth_headers(user)}

      it 'works!' do
        expect(response).to have_http_status :no_content
      end
    end

    context 'When not authenticated' do
      before { delete "/api/users/#{user.id}/credit_lines/#{credit_line.id}/withdrawals/#{withdrawal.id}", headers: reg_headers}

      it 'has response 401 (unauthorized)' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

end
