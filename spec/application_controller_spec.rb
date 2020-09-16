require_relative "spec_helper"

def app
  ApplicationController
end

describe ApplicationController do
  it "responds with a welcome message" do
    get '/'

    res = JSON.parse(last_response.body, symbolize_names: true)
    message ='Hello Practice Hackers!'
    expect(last_response.status).to eq(200)
    expect(res[:message]).to eq(message)
  end

  it 'return search results' do
    search_term = 'violin'
    get "/api/v1/search?q=#{search_term}"

    res = JSON.parse(last_response.body, symbolize_names: true)
    expect(res.keys).to eq([:next, :results])
    expect(res[:results][1]).to include(:composer, :work)
    expect(res[:results][1][:composer]).to include(:name, :id)
    expect(res[:results][1][:work]).to include(:title, :id, :subtitle)
  end

  it 'return search results' do
    search_term = 'qwerewe'
    get "/api/v1/search?q=#{search_term}"

    res = JSON.parse(last_response.body, symbolize_names: true)
    expect(res.keys).to eq([:results])
    expect(res[:results]).to eq([])
  end
end
