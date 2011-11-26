require 'test_helper'
require 'rack_test_case'
require 'sidestep/server'

module Sidestep
  class ServerTest < Rack::TestCase
    FAKE_ROUTES = {
      :data => [{ :route_id => 1, :route_long_name => "My Route" }],
      :json => '[{"route_id":1,"route_long_name":"My Route"}]'
    }

    FAKE_STOPS = {
      :data => [{ :route_id => 0, :stop_id => 1, :stop_name => "My Stop" }],
      :json => '[{"route_id":0,"stop_id":1,"stop_name":"My Stop"}]'
    }

    FAKE_REMAINING_STOPS = {
      :data => [{ :stop_name => 'My Stop', :arrival_time => '18:00:00' }],
      :json => '[{"stop_name":"My Stop","arrival_time":"18:00:00"}]'
    }

    test 'get root' do
      get '/'
      assert_response :ok
      assert_content_type :html
      assert_body_includes('Routes')
    end

    test '/routes' do
      TransitFeed.any_instance.expects(:routes).returns(FAKE_ROUTES[:data])

      get '/routes'
      assert_json_response(FAKE_ROUTES[:json])
    end

    test '/routes/:route_id/stops' do
      TransitFeed.any_instance.
        expects(:stops_for_route).
        with(11).
        returns(FAKE_STOPS[:data])

      get '/routes/11/stops'
      assert_json_response(FAKE_STOPS[:json])
    end

    test '/routes/:route_id/stops/:stop_id/departures' do
      TransitFeed.any_instance.
        expects(:next_departures_on_route_for_stop).
        with(11, 83).
        returns(FAKE_STOPS[:data])

      get 'routes/11/stops/83/departures'
      assert_json_response(FAKE_STOPS[:json])
    end

    test '/trips/:trip_id/stops/:stop_id/remaining' do
      TransitFeed.any_instance.
        expects(:remaining_stops_for_trip).
        with(2310, 83).
        returns(FAKE_REMAINING_STOPS[:data])

      get '/trips/2310/stops/83/remaining'
      assert_json_response(FAKE_REMAINING_STOPS[:json])
    end

    private
      def app
        Sidestep::Server
      end

      def assert_json_response(expected)
        assert_response :ok
        assert_content_type :json
        assert_equal expected, last_response.body
      end
  end
end
