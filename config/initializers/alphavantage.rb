require 'alphavantage'

Alphavantage.configure do |config|
  config.api_key = ENV['API_KEY']
end
