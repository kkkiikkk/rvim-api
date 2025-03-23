Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/api/admin", as: "rails_admin"

  namespace :api do
    resources :posts, only: [ :index, :show ] do
      get :get_video, on: :member
    end

    resources :categories

    scope :videos do
      get "/:id/stream.m3u8", to: "videos#stream", as: :video_stream
      get "/:id/:segment", to: "videos#segment", constraints: { segment: /stream\d+\.ts/ }, as: :video_segment
    end
  end
end
