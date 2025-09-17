require "net/http"
require "open-uri"

class TranscriptionJob < ApplicationJob
  queue_as :default

  def perform(transcription_id)
    Rails.logger.info "Running TranscriptionJob for ID: #{transcription_id}"
    transcription = Transcription.find(transcription_id)

    begin
      transcription.update!(status: :pending)

      unless transcription.audio_file.attached?
        raise "Audio file is not attached to transcription ##{transcription.id}"
      end

      # Generate direct URL to the audio blob
      file_url = Rails.application.routes.url_helpers.rails_blob_url(transcription.audio_file, only_path: false)
      Rails.logger.info "Fetching file from #{file_url}"

      # Create a tempfile with appropriate extension
      ext = File.extname(URI.parse(file_url).path).presence || ".wav"
      downloaded_file = Tempfile.new(["audio", ext])
      downloaded_file.binmode

      # Stream the remote file into the tempfile
      URI.open(file_url) do |remote_file|
        downloaded_file.write(remote_file.read)
      end
      downloaded_file.rewind

      # Send audio to Whisper API
      whisper_response = call_openai_whisper(downloaded_file)

      transcription.update!(
        ai_response: whisper_response,
        status: :transcribed
      )
      Rails.logger.info "Transcription completed successfully."

    rescue => e
      Rails.logger.error "TranscriptionJob failed: #{e.message}"
      transcription.update!(status: :failed)
      raise e
    ensure
      downloaded_file.close! if downloaded_file
      downloaded_file.unlink if downloaded_file
    end
  end

  private

  def call_openai_whisper(file)
    api_key = ENV["OPENAI_ACCESS_TOKEN"]
    uri = URI("https://api.openai.com/v1/audio/transcriptions")

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{api_key}"

    form_data = [
      ["file", file],
      ["model", "whisper-1"],
      ["response_format", "json"],
      ["language", ENV.fetch("WHISPER_LANG", "en")]
    ]
    request.set_form(form_data, "multipart/form-data")

    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true
    response = http.request(request)

    unless response.is_a?(Net::HTTPSuccess)
      raise "Whisper API error: #{response.body}"
    end

    JSON.parse(response.body)
  end
end
