class Api::VideosController < ApplicationController
  before_action :set_cors_headers

  def stream
    post = find_post
    return head :not_found unless post_hls_available?(post)

    send_file post.m3u8_path, type: "application/vnd.apple.mpegurl", disposition: "inline"
  end

  def segment
    post = find_post
    segment_path = build_segment_path(post.id, params[:segment])

    return send_file(segment_path, type: "video/MP2T", disposition: "inline") if File.exist?(segment_path)

    head :not_found
  end

  private

  def set_cors_headers
    response.set_header("Access-Control-Allow-Origin", "*")
    response.set_header("Access-Control-Allow-Methods", "GET, OPTIONS")
    response.set_header("Access-Control-Allow-Headers", "*")
  end

  def find_post
    Post.find_by(id: params[:id])
  end

  def post_hls_available?(post)
    post&.m3u8_path && File.exist?(post.m3u8_path)
  end

  def build_segment_path(post_id, segment_filename)
    Rails.root.join("public/videos/#{post_id}/#{segment_filename}")
  end
end
