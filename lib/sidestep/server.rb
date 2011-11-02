require File.join(File.dirname(__FILE__), '../sidestep')

module Sidestep
  # The main application server.
  class Server < Sinatra::Base
    set :app_file, __FILE__
    set :public_folder, Proc.new { File.join(root, '../../public') }

    get '/' do
      File.read(File.join('public', 'index.html'))
    end

    get '/routes' do
      content_type :json
      FEED.routes.to_json
    end
  end
end
