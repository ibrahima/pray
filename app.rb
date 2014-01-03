#!/usr/bin/env ruby

require 'sinatra'
require 'sequel'
require "sinatra/json"


configure {
  set :server, :puma
  db = Sequel.sqlite("db/downloads.db")
  require './download'
}

class Pumatra < Sinatra::Base
  helpers Sinatra::JSON

  get '/' do
    Download.all.map do |dl|
      "#{dl.path} => #{dl.count}"
    end.join " --\n\n"
  end

  get '/counter' do
    path = params["file"]
    status = params["status"]

    counter = Download[path: path]
    counter = Download.create(path: path, count: 0) if counter.nil?
    if status == "OK"
      counter.count = counter.count + 1
      counter.save
    end
    return "Counted #{path}, #{counter.count} downloads #{counter.count.class}, status=#{status}"
  end

  get '/get_counts' do
    path = params["file"]
    counter = Download[path: path]
    if counter
      json path: path, count: counter.count
    else
      status 404
      json path: path, count: 0
    end
  end
  run! if app_file == $0
end
