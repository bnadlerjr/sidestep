require 'test_helper'
require 'rack_test_case'
require 'sidestep/server'

module Sidestep
  class ServerTest < Rack::TestCase
    test 'get root' do
      get '/'
      assert_response :ok
      assert_content_type :html
      assert_body_includes('Routes')
    end

    test '/routes' do
      expected = '[{"route_id":1,"route_long_name":"My Route"}]'

      TransitFeed.any_instance.expects(:routes).returns([
        { :route_id => 1, :route_long_name => "My Route" }
      ])

      get '/routes'
      assert_response :ok
      assert_content_type :json
      assert_equal expected, last_response.body
    end

    private
      def app
        Sidestep::Server
      end
  end
end
