require 'net/http'
require 'json'

class Stock < ApplicationRecord
  BASE_URI = 'https://www.alphavantage.co'

  def self.company_lookup(ticker_symbol)
    response = get("/query?function=OVERVIEW&symbol=#{ticker_symbol}&apikey=#{ENV['API_KEY']}")
    handle_response(response)['Name']
  end

  def self.new_lookup(ticker_symbol)
    response = get("/query?function=GLOBAL_QUOTE&symbol=#{ticker_symbol}&apikey=#{ENV['API_KEY']}")
    if response.is_a?(Net::HTTPSuccess)
      quote = JSON.parse(response.body)['Global Quote']
      if quote
        last_price = quote['05. price']
        name = company_lookup(ticker_symbol)
        new(ticker: ticker_symbol, name: name, last_price: last_price)
      end
    end
  end

  private

  def self.api_key
    ENV['API_KEY']
  end

  def self.get(path)
    uri = URI("#{BASE_URI}#{path}")
    Net::HTTP.get_response(uri)
  end

  def self.handle_response(response)
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      Rails.logger.error "API request failed: #{response.code} - #{response.message}"
      nil
    end
  end
end
