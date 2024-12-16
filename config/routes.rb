Rails.application.routes.draw do
  namespace :api do
    resources :posts, only: [ :index, :show ] do
      get :get_video, on: :member
    end

    resources :categories
  end
end
