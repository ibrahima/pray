#!/usr/bin/env ruby

require 'sinatra'

configure {
  set :server, :puma
}

class Pumatra < Sinatra::Base
  get '/' do
    return 'It works!'
  end

  get '/counter' do
    path = params["Path"]
    return "Counted #{path}"
  end

  run! if app_file == $0
end
