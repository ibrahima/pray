#!/usr/bin/env ruby

require 'sinatra'
require 'sequel'
require "sinatra/json"


configure {
  set :server, :puma
  db = Sequel.sqlite("db/pray.db")
  require './person'
}

class Pumatra < Sinatra::Base
  helpers Sinatra::JSON

  get '/pray/view' do
    Person.all.each do |person|
      if person.arrival_time < (Time.now - 120)
        person.delete
      end
    end
    @people = Person.all
    haml :index
  end
  
  get '/pray/register' do
    text = params[:text]
    minutes = text.to_i
    arrival_time = Time.now + minutes*60
    Person.create(arrival_time: arrival_time)
    return "hi! #{text}"
  end

  post '/pray/register' do
    text = params[:text]
    minutes = text.to_i
    arrival_time = Time.now + minutes*60
    Person.create(arrival_time: arrival_time)
    return "hi!"
  end

  run! if app_file == $0
end
