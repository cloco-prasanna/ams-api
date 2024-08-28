Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      get "tokens/create"
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[index show create update destroy]
      resources :tokens, only: [ :create ]
      resources :artists, only: %i[index show create update destroy] do
        resources :musics, only: %i[index show]
      end
    end
  end
end
