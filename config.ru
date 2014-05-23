#!/usr/bin/env ruby

require 'bundler'
Bundler.require(:default)

require './app'

use Rack::Coffee, root: 'public', urls: '/javascripts'

run Pumatra

