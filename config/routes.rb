BostonStartupMap::Application.routes.draw do
  devise_for :users do get '/users/sign_out' => 'devise/sessions#destroy' end

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  resources :companies
  root :to => "companies#index"
end
