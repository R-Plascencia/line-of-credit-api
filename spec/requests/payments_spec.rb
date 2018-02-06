require 'rails_helper'

RSpec.describe "Payments", type: :request do
  let(:user) { FactoryBot.create(:user)}
  let(:credit_line) { FactoryBot.create(:credit_line, user_id: user.id) }
  let(:payment) { FactoryBot.create(:payment, credit_line_id: credit_line.id) }
  let(:reg_headers) do
    { 'Accept': 'application/json' }
  end

  describe "GET #index" do

    context 'When authenticated' do
      before { get "/api/users/#{user.id}/credit_lines/#{credit_line.id}/payments", headers: auth_headers(user)}

      it "works!" do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'When not authenticated' do
      before { get "/api/users/#{user.id}/credit_lines/#{credit_line.id}/payments", headers: reg_headers}

      it "works!" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

  end
end
