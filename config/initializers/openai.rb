require "openai"

OpenAI.configure do |config|
  config.access_token = ENV["OPENAI_ACCESS_TOKEN"] || "dummy"
  config.organization_id = ENV["OPENAI_ORGANIZATION_ID"] || "dummy"
end