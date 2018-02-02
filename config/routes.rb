Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  scope '/api' do
    resources :users do
      resources :credit_lines do
        resources :payments
        resources :withdrawals
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
