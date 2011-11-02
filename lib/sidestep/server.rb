require File.join(File.dirname(__FILE__), '../sidestep')

module Sidestep
  # The main application server.
  class Server < Sinatra::Base
    set :app_file, __FILE__
    set :public_folder, Proc.new { File.join(root, '../../public') }

    before do
      content_type :json
    end

    get '/' do
      content_type :html
      File.read(File.join('public', 'index.html'))
    end

    get '/routes' do
      FEED.routes.to_json
    end

    get '/routes/:route_id/stops' do
      FEED.stops_for_route(params[:route_id].to_i).to_json
    end

    get '/routes/:route_id/stops/:stop_id/departures' do
      FEED.next_departures_on_route_for_stop(
        params[:route_id].to_i, params[:stop_id].to_i).to_json
    end
  end
end
