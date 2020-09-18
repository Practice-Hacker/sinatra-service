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

  it 'gets a single response when searching by open opus work id' do
    openopus_work_id = "100"
    get "/api/v1/piece/#{openopus_work_id}"

    response = JSON.parse(last_response.body, symbolize_names: true)
    expect(response.keys).to include(:composer, :work)
    expect(response[:composer]).to include(:name, :id)
    expect(response[:work]).to include(:title, :subtitle, :id)
  end

  it 'returns 404 if searching by openopus work id is unsuccessful' do
    openopus_work_id = "99999999999999999"
    get "/api/v1/piece/#{openopus_work_id}"

    expect(last_response.status).to eq(404)
  end

  describe "offset" do
    before(:each) do
      stub_request(:get, "api.openopus.org")
    end

    it "defaults to zero" do
      search_term = 'violin'
      get "/api/v1/search?q=#{search_term}"
      expect(a_request(:get, /0.json/)).to have_been_made
      # regular expression that will match a string that contains 0.json

    end

    it "accepts a param" do
      search_term = 'violin'
      get "/api/v1/search?q=#{search_term}&offset=20"
      expect(a_request(:get, /20.json/)).to have_been_made
    end
  end
end
