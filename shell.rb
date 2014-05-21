#!/usr/bin/env ruby
require 'bundler'
Bundler.setup

require 'sequel'
require 'pry'
db = Sequel.sqlite 'db/pray.db'
require './person'

binding.pry
