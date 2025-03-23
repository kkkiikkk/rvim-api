Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/api/admin', as: 'rails_admin'
  namespace :api do
    resources :posts, only: [ :index, :show ] do
      get :get_video, on: :member
    end

    resources :categories
  end
end
