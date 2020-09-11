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
end
