class Api::PostsController < ApplicationController
  include ActiveStorage::Streaming

  def index
    posts = Post.newest
    posts = FilterPostQuery.new(posts, params).call

    render json: posts, each_serializer: PostSerializer
  end

  def show
    render json: post, each_serializer: PostSerializer
  end

  def get_video
    http_cache_forever(public: true) do
      send_blob_stream post.video, disposition: params[:disposition]
    end
  end

  private

  def post
    Post.find(params[:id])
  end
end
