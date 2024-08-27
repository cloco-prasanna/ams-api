Rails.application.routes.draw do  

  get "up" => "rails/health#show", as: :rails_health_check
  namespace :api, defaults: {format: :json} do
  end

end
