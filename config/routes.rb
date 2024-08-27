Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "tokens/create"
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[show create update destroy]
      resources :tokens, only: [ :create ]
    end
  end
end
