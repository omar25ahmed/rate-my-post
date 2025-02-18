Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :posts, only: %i[create] do
        resources :ratings, only: %i[create]
        collection do
          get :top
          get :ips
        end
      end
    end
  end
end
