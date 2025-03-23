require "streamio-ffmpeg"

class TranscodeVideoJob < ApplicationJob
  queue_as :default

  HLS_OPTIONS = %w[-start_number 0 -hls_time 10 -hls_list_size 0 -f hls].freeze

  def perform(post)
    return log_and_exit("No attached video", post) unless post.video.attached?

    log("Started transcoding")

    input_tempfile = safely_download(post)
    return unless input_tempfile

    transcode_video(post, input_tempfile)
  ensure
    cleanup_tempfile(input_tempfile)
  end

  private

  def transcode_video(post, input_tempfile)
    output_dir = Rails.root.join("public/videos/#{post.id}")
    output_path = output_dir.join("stream.m3u8")

    FileUtils.mkdir_p(output_dir)

    movie = FFMPEG::Movie.new(input_tempfile.path)
    unless movie.valid?
      return log_and_exit("Invalid video file, FFmpeg failed to parse", post)
    end

    log("Video info", post, duration: movie.duration, resolution: movie.resolution)

    movie.transcode(output_path.to_s, HLS_OPTIONS)
    log("Successfully transcoded", post, output: output_path.to_s)
  rescue => e
    log_error("Transcoding failed", post, error: e.message)
  end

  def safely_download(post)
    file = Tempfile.new(["uploaded", ".mp4"], binmode: true)

    post.video.download { |chunk| file.write(chunk) }

    file.rewind
    file
  rescue => e
    log_error("Video download failed", post, error: e.message)
    cleanup_tempfile(file)
    nil
  end

  def cleanup_tempfile(file)
    return unless file

    file.close
    file.unlink
  end

  def log(message, post = nil, extra = {})
    Rails.logger.info(build_log(message, post, extra))
  end

  def log_error(message, post = nil, extra = {})
    Rails.logger.error(build_log(message, post, extra))
  end

  def log_and_exit(message, post)
    log_error(message, post)
    nil
  end

  def build_log(message, post, extra = {})
    base = "[TranscodeVideoJob]"
    post_info = post ? " Post##{post.id}" : ""
    extras = extra.present? ? " | #{extra.map { |k, v| "#{k}=#{v}" }.join(', ')}" : ""
    "#{base}#{post_info} - #{message}#{extras}"
  end
end
