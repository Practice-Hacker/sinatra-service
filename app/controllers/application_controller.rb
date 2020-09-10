require './config/environment'

class ApplicationController < Sinatra::Base

  get '/' do
    {message: 'yay!!'}
  end

end
