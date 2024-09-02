Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :tokens, only: [ :create ]
      resources :users, only: %i[index show create update destroy]
      resources :artists, only: %i[index show create update destroy] do
        resources :musics, only: %i[index show create update destroy] do
          collection do
            get :genres, to: "musics#genre_musics"
          end
        end
        collection do
          post :import
        end
      end
    end
  end
end
