require "test_helper"
require "sidestep/transit_feed"

module Sidestep
  class TransitFeedTest < Test::Unit::TestCase
    filename = File.join(File.dirname(__FILE__), "../../db/transit_data.db")
    DB = Sequel.sqlite(filename)

    setup do
      @feed = Sidestep::TransitFeed.new(DB)
    end

    test "create a new transit feed" do
      assert @feed, "expected to able to create a new transit feed"
    end

    test "retrieve routes" do
      expected = [
        { :route_id => 2, :route_long_name => "Atlantic City Rail Line" },
        { :route_id => 9, :route_long_name => "Gladstone Branch" },
        { :route_id => 5, :route_long_name => "Hudson-Bergen Light Rail" },
        { :route_id => 6, :route_long_name => "Main/Bergen County Line" },
        { :route_id => 19, :route_long_name => "Meadowlands Rail Line" },
        { :route_id => 3, :route_long_name => "Montclair-Boonton Line" },
        { :route_id => 4, :route_long_name => "Montclair-Boonton Line" },
        { :route_id => 8, :route_long_name => "Morris & Essex Line" },
        { :route_id => 14, :route_long_name => "Newark Light Rail" },
        { :route_id => 12, :route_long_name => "North Jersey Coast Line" },
        { :route_id => 13, :route_long_name => "North Jersey Coast Line" },
        { :route_id => 11, :route_long_name => "Northeast Corridor" },
        { :route_id => 15, :route_long_name => "Pascack Valley Line" },
        { :route_id => 7, :route_long_name => "Port Jervis Line" },
        { :route_id => 1, :route_long_name => "Princeton Shuttle" },
        { :route_id => 16, :route_long_name => "Princeton Shuttle" },
        { :route_id => 17, :route_long_name => "Raritan Valley Line" },
        { :route_id => 18, :route_long_name => "Riverline Light Rail" }
      ]

      assert_equal expected, @feed.routes
    end

    test "retrieve stops for a route" do
      expected = [
        { :stop_id => 38, :stop_name => "EDISON STATION" },
        { :stop_id => 41, :stop_name => "ELIZABETH" },
        { :stop_id => 38187, :stop_name => "FRANK R LAUTENBERG SECAUCUS UPPER LEVEL" },
        { :stop_id => 32905, :stop_name => "HAMILTON" },
        { :stop_id => 32906, :stop_name => "JERSEY AVE." },
        { :stop_id => 70, :stop_name => "LINDEN" },
        { :stop_id => 83, :stop_name => "METROPARK" },
        { :stop_id => 84, :stop_name => "METUCHEN" },
        { :stop_id => 103, :stop_name => "NEW BRUNSWICK" },
        { :stop_id => 105, :stop_name => "NEW YORK PENN STATION" },
        { :stop_id => 37953, :stop_name => "NEWARK AIRPORT RAILROAD STATION" },
        { :stop_id => 107, :stop_name => "NEWARK PENN STATION" },
        { :stop_id => 109, :stop_name => "NORTH ELIZABETH" },
        { :stop_id => 125, :stop_name => "PRINCETON JCT." },
        { :stop_id => 127, :stop_name => "RAHWAY" },
        { :stop_id => 148, :stop_name => "TRENTON TRANSIT CENTER" }
      ]

      assert_equal expected, @feed.stops_for_route(11)
    end
  end
end
