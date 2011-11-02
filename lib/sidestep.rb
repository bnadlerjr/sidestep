require 'rubygems'
require 'bundler'
Bundler.setup

$:.push File.dirname(__FILE__)

require "haml"
require "json"
require "sequel"
require 'sinatra/base'

require "sidestep/transit_feed"

DB = Sequel.sqlite(File.join(File.dirname(__FILE__), "../db/transit_data.db"))
FEED = Sidestep::TransitFeed.new(DB)
