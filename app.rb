#!/usr/bin/env ruby

require 'sinatra'
require 'sequel'
require "sinatra/json"
require 'nexmo'
require 'yaml'

configure {
  set :server, :puma
  db = Sequel.sqlite("db/pray.db")
  require './person'
  enable :logging
}

class Pumatra < Sinatra::Base
  helpers Sinatra::JSON
  
  def initialize
    nexmo_conf = YAML.load_file('config/nexmo.yml')
    @nexmo = Nexmo::Client.new(nexmo_conf["api_key"], nexmo_conf["api_secret"])
    super
  end

  get '/pray/view' do
    Person.all.each do |person|
      if person.arrival_time < (Time.now - 120)
        person.delete
      end
    end
    @people = Person.all
    haml :index
  end
  
  get '/pray/smscallback' do
    text = params[:text]
    if text.start_with? "list"
      people_count = Person.where{arrival_time > Time.now - 120}.where{arrival_time < Time.now + 300}.count
      pronoun = if people_count == 1 then "person" else "people" end
      suffix = if people_count > 0 then "iA" else ":(" end
      message = "#{people_count} #{pronoun} arriving in the next 5 minutes #{suffix}"
      sender = params[:msisdn]
      response = @nexmo.send_message({:to => sender, :from => "12132633592", :text => message})
      if response.ok?
        return "success"
      else
        return "fail"
      end
    else
      minutes = text.to_i
      arrival_time = Time.now + minutes*60
      Person.create(arrival_time: arrival_time)
      return "success"
      # redirect to('/pray/view')
    end
  end

  post '/pray/smscallback' do
    text = params[:text]
    minutes = text.to_i
    arrival_time = Time.now + minutes*60
    Person.create(arrival_time: arrival_time)
    redirect to('/pray/view')
  end


  post '/pray/register' do
    text = params[:eta]
    minutes = text.to_i
    arrival_time = Time.now + minutes*60
    Person.create(arrival_time: arrival_time)
    redirect to('/pray/view')
  end


  run! if app_file == $0
end
