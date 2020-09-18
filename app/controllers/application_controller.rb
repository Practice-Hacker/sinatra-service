require './config/environment'

class ApplicationController < Sinatra::Base

  before do
    content_type 'application/json'
  end

  get '/' do
    JSON.generate(message: 'Hello Practice Hackers!')
  end

  get '/api/v1/search' do
    offset = params[:offset] || '0'
    data = Faraday.get("https://api.openopus.org/omnisearch/#{params[:q]}/#{offset}.json")
    parsed_data = JSON.parse(data.body, symbolize_names: true)

    not_found = { results: []}
    return not_found.to_json if parsed_data[:results].nil?

    response = {
      next: parsed_data[:next],
      results: parsed_data[:results].map do |raw|
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
        result
      end
    }

    response.to_json
  end

  get '/api/v1/piece/:work_id' do
    data = Faraday.get("https://api.openopus.org/work/list/ids/#{params[:work_id]}.json")
    parsed_data = JSON.parse(data.body, symbolize_names: true)

    return status 404 if parsed_data[:status][:success] == "false"

    response = {
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

    response[:composer][:name] = parsed_data[:works][:"w:#{params[:work_id]}"][:composer][:complete_name]
    response[:composer][:id] = parsed_data[:works][:"w:#{params[:work_id]}"][:composer][:id]
    response[:work][:title] = parsed_data[:works][:"w:#{params[:work_id]}"][:title]
    response[:work][:subtitle] = parsed_data[:works][:"w:#{params[:work_id]}"][:subtitle]
    response[:work][:id] = parsed_data[:works][:"w:#{params[:work_id]}"][:id]

    response.to_json
  end
end
