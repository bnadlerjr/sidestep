require File.join(File.dirname(__FILE__), 'lib/sidestep/server')
require 'sprockets'

map '/assets' do
  env = Sprockets::Environment.new
  env.append_path 'lib/sidestep/assets/javascripts'
  env.append_path 'lib/sidestep/assets/stylesheets'
  run env
end

map '/' do
  run Sidestep::Server
end
