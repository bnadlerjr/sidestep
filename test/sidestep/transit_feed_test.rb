require "test_helper"
require "sidestep/transit_feed"

module Sidestep
  class TransitFeedTest < Test::Unit::TestCase
    filename = File.join(File.dirname(__FILE__), "../../db/transit_data.db")
    DB = Sequel.sqlite(filename)

    NORTHEAST_CORRIDOR = 11
    METROPARK = 83
    NEW_YORK_PENN = 105

    setup do
      @feed = Sidestep::TransitFeed.new(DB)
    end

    test "create a new transit feed" do
      assert @feed, "expected to able to create a new transit feed"
    end

    test "retrieve routes" do
      Date.stubs(:today).returns(Date.parse("2011-12-15"))
      expected = [
        { :route_id => 2, :route_long_name => "Atlantic City Rail Line" },
        { :route_id => 9, :route_long_name => "Gladstone Branch" },
        { :route_id => 5, :route_long_name => "Hudson-Bergen Light Rail" },
        { :route_id => 6, :route_long_name => "Main/Bergen County Line" },
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
        {:route_id=>18, :route_long_name=>"Riverline Light Rail"}
      ]

      assert_equal expected, @feed.routes
    end

    test "retrieve stops for a route" do
      expected = [
        { :route_id => 11, :stop_id => 38, :stop_name => "EDISON STATION" },
        { :route_id => 11, :stop_id => 41, :stop_name => "ELIZABETH" },
        { :route_id => 11, :stop_id => 38187, :stop_name => "FRANK R LAUTENBERG SECAUCUS UPPER LEVEL" },
        { :route_id => 11, :stop_id => 32905, :stop_name => "HAMILTON" },
        { :route_id => 11, :stop_id => 32906, :stop_name => "JERSEY AVE." },
        { :route_id => 11, :stop_id => 70, :stop_name => "LINDEN" },
        { :route_id => 11, :stop_id => 83, :stop_name => "METROPARK" },
        { :route_id => 11, :stop_id => 84, :stop_name => "METUCHEN" },
        { :route_id => 11, :stop_id => 103, :stop_name => "NEW BRUNSWICK" },
        { :route_id => 11, :stop_id => 105, :stop_name => "NEW YORK PENN STATION" },
        { :route_id => 11, :stop_id => 37953, :stop_name => "NEWARK AIRPORT RAILROAD STATION" },
        { :route_id => 11, :stop_id => 107, :stop_name => "NEWARK PENN STATION" },
        { :route_id => 11, :stop_id => 109, :stop_name => "NORTH ELIZABETH" },
        { :route_id => 11, :stop_id => 125, :stop_name => "PRINCETON JCT." },
        { :route_id => 11, :stop_id => 127, :stop_name => "RAHWAY" },
        { :route_id => 11, :stop_id => 148, :stop_name => "TRENTON TRANSIT CENTER" }
      ]

      assert_equal expected, @feed.stops_for_route(NORTHEAST_CORRIDOR)
    end

    context "retrieve next departures for a stop on a route" do
      setup do
        Time.stubs(:now).returns(DateTime.parse("2011-11-26 18:00:00"))
        @result = @feed.next_departures_on_route_for_stop(NORTHEAST_CORRIDOR, METROPARK)
      end

      test "check total" do
        assert_equal 25, @result.count
      end

      test "check format" do
        expected = {
          :trip_id => 1738, :stop_id => 83, :departure_time => "18:14:00",
          :trip_headsign => "NEW YORK PENN STATION"
        }

        assert_equal expected, @result.first
      end

      test "reformats departure times after midnight" do
        expected = [
          { :trip_id => 1663, :stop_id => 83, :departure_time => "01:42:00",
            :trip_headsign=>"NEW YORK PENN STATION" },
          { :trip_id => 1798, :stop_id => 83, :departure_time => "02:06:00",
          :trip_headsign=>"TRENTON TRANSIT CENTER" }
        ]

        assert_equal expected[1], @result.pop
        assert_equal expected[0], @result.pop
      end

      test "do not show current station" do
        expected = [
          { :trip_id => 1886, :stop_id => 105, :departure_time => "18:14:00",
            :trip_headsign=>"TRENTON TRANSIT CENTER" },
          { :trip_id => 1901, :stop_id => 105, :departure_time => "18:53:00",
            :trip_headsign=>"RAHWAY" },
          { :trip_id => 1875, :stop_id => 105, :departure_time => "19:03:00",
            :trip_headsign=>"TRENTON TRANSIT CENTER" },
          { :trip_id => 1887, :stop_id => 105, :departure_time => "19:13:00",
            :trip_headsign=>"TRENTON TRANSIT CENTER" },
          { :trip_id => 1904, :stop_id => 105, :departure_time => "19:51:00",
            :trip_headsign=>"RAHWAY" },
          { :trip_id => 1876, :stop_id => 105, :departure_time => "20:03:00",
            :trip_headsign=>"TRENTON TRANSIT CENTER" },
          { :trip_id => 1888, :stop_id => 105, :departure_time => "20:14:00",
            :trip_headsign=>"TRENTON TRANSIT CENTER" },
          { :trip_id => 1867, :stop_id => 105, :departure_time => "21:01:00",
            :trip_headsign=>"TRENTON TRANSIT CENTER" },
          { :trip_id => 1889, :stop_id => 105, :departure_time => "21:14:00",
            :trip_headsign=>"TRENTON TRANSIT CENTER" },
          { :trip_id => 1868, :stop_id => 105, :departure_time => "21:57:00",
            :trip_headsign=>"TRENTON TRANSIT CENTER" },
          { :trip_id => 1890, :stop_id => 105, :departure_time => "22:14:00",
            :trip_headsign=>"TRENTON TRANSIT CENTER" },
          { :trip_id => 1869, :stop_id => 105, :departure_time => "22:57:00",
            :trip_headsign=>"TRENTON TRANSIT CENTER" },
          { :trip_id => 1891, :stop_id => 105, :departure_time => "23:14:00",
            :trip_headsign=>"TRENTON TRANSIT CENTER" },
          { :trip_id => 1866, :stop_id => 105, :departure_time => "23:56:00",
            :trip_headsign=>"TRENTON TRANSIT CENTER" },
          { :trip_id => 1797, :stop_id => 105, :departure_time => "00:43:00",
            :trip_headsign=>"TRENTON TRANSIT CENTER" },
          { :trip_id => 1798, :stop_id => 105, :departure_time => "01:22:00",
            :trip_headsign=>"TRENTON TRANSIT CENTER" }
      ]

        result = @feed.next_departures_on_route_for_stop(NORTHEAST_CORRIDOR, NEW_YORK_PENN)

        assert_equal expected, result
      end
    end

    test "retrieve stops for a trip starting from a specific stop" do
      expected = [
        { :stop_name => "METROPARK", :arrival_time => "18:14:00" },
        { :stop_name => "NEWARK AIRPORT RAILROAD STATION", :arrival_time => "18:28:00" },
        { :stop_name => "NEWARK PENN STATION", :arrival_time => "18:33:00" },
        { :stop_name => "FRANK R LAUTENBERG SECAUCUS UPPER LEVEL", :arrival_time => "18:41:00" },
        { :stop_name => "NEW YORK PENN STATION", :arrival_time => "18:55:00" }
      ]

      assert_equal expected, @feed.remaining_stops_for_trip(1738, 83)
    end
  end
end
