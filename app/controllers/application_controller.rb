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

    parsed_data[:results].each do |raw|
      result = {
          composer: {
            name: nil,
            id: nil
          },
          work: {
            title: nil,
            subtitle: nil,
            id: nil
          }
      }
      result[:composer][:name] = raw[:composer][:complete_name]
      result[:composer][:id] = raw[:composer][:id]
      unless raw[:work].nil?
        result[:work][:title] = raw[:work][:title]
        result[:work][:id] = raw[:work][:id]
        result[:work][:subtitle] = raw[:work][:subtitle]
      end

      info[:results] << result
    end
    info.to_json
  end

end
