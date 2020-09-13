require './config/environment'

class ApplicationController < Sinatra::Base

  before do
    content_type 'application/json'
  end

  get '/' do
    JSON.generate(message: 'Hello Practice Hackers!')
  end

  get '/api/v1/search' do

    data = Faraday.get("https://api.openopus.org/omnisearch/#{params[:q]}/0.json")

    parsed_data = JSON.parse(data.body, symbolize_names: true)
    info = {
        next: parsed_data[:next],
        results: []
    }

    parsed_data[:results].each do |result|
      single_results = {
          composer: {},
          work: {}
      }
      single_results[:composer][:name] = result[:composer][:complete_name]
      single_results[:composer][:id] = result[:composer][:id]
      if result[:work].nil?
        single_results[:work][:title] = nil
      else
        single_results[:work][:title] = result[:work][:title]
        single_results[:work][:id] = result[:work][:id]
        single_results[:work][:subtitle] = result[:work][:subtitle]
      end

      info[:results] << single_results
    end
    info.to_json
  end

end
