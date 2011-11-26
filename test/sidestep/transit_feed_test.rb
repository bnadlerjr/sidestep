require "test_helper"
require "sidestep/transit_feed"

module Sidestep
  class TransitFeedTest < Test::Unit::TestCase
    filename = File.join(File.dirname(__FILE__), "../../db/transit_data.db")
    DB = Sequel.sqlite(filename)

    NORTHEAST_CORRIDOR = 11
    METROPARK = 83

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

      assert_equal expected, @feed.stops_for_route(NORTHEAST_CORRIDOR)
    end

    test "retrieve next departures for a stop" do
      expected = [
        { :trip_id => 2281, :departure_time => "18:14:00"},
        { :trip_id => 2310, :departure_time => "18:14:00" },
        { :trip_id => 2375, :departure_time => "18:15:00" },
        { :trip_id => 2394, :departure_time => "18:15:00" },
        { :trip_id => 2433, :departure_time => "18:15:00" },
        { :trip_id => 2482, :departure_time => "18:27:00" },
        { :trip_id => 2519, :departure_time => "18:27:00" },
        { :trip_id => 2183, :departure_time => "18:30:00" },
        { :trip_id => 2216, :departure_time => "18:30:00" },
        { :trip_id => 2522, :departure_time => "18:31:00" },
        { :trip_id => 2561, :departure_time => "18:31:00" },
        { :trip_id => 2305, :departure_time => "18:42:00" },
        { :trip_id => 2334, :departure_time => "18:42:00" },
        { :trip_id => 2376, :departure_time => "18:53:00" },
        { :trip_id => 2401, :departure_time => "18:53:00" },
        { :trip_id => 2413, :departure_time => "18:53:00" },
        { :trip_id => 2147, :departure_time => "18:57:00" },
        { :trip_id => 2180, :departure_time => "18:57:00" },
        { :trip_id => 2550, :departure_time => "18:57:00" },
        { :trip_id => 2585, :departure_time => "18:57:00" },
        { :trip_id => 2283, :departure_time => "19:14:00" },
        { :trip_id => 2312, :departure_time => "19:14:00" },
        { :trip_id => 2377, :departure_time => "19:14:00" },
        { :trip_id => 2502, :departure_time => "19:18:00" },
        { :trip_id => 2541, :departure_time => "19:18:00" },
        { :trip_id => 2173, :departure_time => "19:21:00" },
        { :trip_id => 2206, :departure_time => "19:21:00" },
        { :trip_id => 2402, :departure_time => "19:25:00" },
        { :trip_id => 2439, :departure_time => "19:25:00" },
        { :trip_id => 2134, :departure_time => "19:32:00" },
        { :trip_id => 2524, :departure_time => "19:40:00" },
        { :trip_id => 2563, :departure_time => "19:40:00" },
        { :trip_id => 2307, :departure_time => "19:42:00" },
        { :trip_id => 2336, :departure_time => "19:42:00" },
        { :trip_id => 2203, :departure_time => "19:49:00" },
        { :trip_id => 2236, :departure_time => "19:49:00" },
        { :trip_id => 2382, :departure_time => "19:54:00" },
        { :trip_id => 2419, :departure_time => "19:54:00" },
        { :trip_id => 2552, :departure_time => "19:58:00" },
        { :trip_id => 2587, :departure_time => "19:58:00" },
        { :trip_id => 2175, :departure_time => "20:28:00" },
        { :trip_id => 2208, :departure_time => "20:28:00" },
        { :trip_id => 2458, :departure_time => "20:28:00" },
        { :trip_id => 2497, :departure_time => "20:28:00" },
        { :trip_id => 2136, :departure_time => "20:32:00" },
        { :trip_id => 2526, :departure_time => "20:41:00" },
        { :trip_id => 2565, :departure_time => "20:41:00" },
        { :trip_id => 2309, :departure_time => "20:42:00" },
        { :trip_id => 2338, :departure_time => "20:42:00" },
        { :trip_id => 2460, :departure_time => "20:56:00" },
        { :trip_id => 2499, :departure_time => "20:56:00" },
        { :trip_id => 2554, :departure_time => "20:57:00" },
        { :trip_id => 2588, :departure_time => "20:57:00" },
        { :trip_id => 2396, :departure_time => "21:11:00" },
        { :trip_id => 2435, :departure_time => "21:11:00" },
        { :trip_id => 2185, :departure_time => "21:13:00" },
        { :trip_id => 2218, :departure_time => "21:13:00" },
        { :trip_id => 2138, :departure_time => "21:32:00" },
        { :trip_id => 2508, :departure_time => "21:35:00" },
        { :trip_id => 2547, :departure_time => "21:35:00" },
        { :trip_id => 2311, :departure_time => "21:42:00" },
        { :trip_id => 2340, :departure_time => "21:42:00" },
        { :trip_id => 2406, :departure_time => "21:46:00" },
        { :trip_id => 2445, :departure_time => "21:46:00" },
        { :trip_id => 2177, :departure_time => "21:50:00" },
        { :trip_id => 2210, :departure_time => "21:50:00" },
        { :trip_id => 2556, :departure_time => "21:57:00" },
        { :trip_id => 2589, :departure_time => "21:57:00" },
        { :trip_id => 2408, :departure_time => "22:16:00" },
        { :trip_id => 2447, :departure_time => "22:16:00" },
        { :trip_id => 2187, :departure_time => "22:32:00" },
        { :trip_id => 2220, :departure_time => "22:32:00" },
        { :trip_id => 2510, :departure_time => "22:32:00" },
        { :trip_id => 2549, :departure_time => "22:32:00" },
        { :trip_id => 2313, :departure_time => "22:42:00" },
        { :trip_id => 2342, :departure_time => "22:42:00" },
        { :trip_id => 2398, :departure_time => "22:43:00" },
        { :trip_id => 2437, :departure_time => "22:43:00" },
        { :trip_id => 2410, :departure_time => "22:52:00" },
        { :trip_id => 2449, :departure_time => "22:52:00" },
        { :trip_id => 2558, :departure_time => "22:57:00" },
        { :trip_id => 2590, :departure_time => "22:57:00" },
        { :trip_id => 2412, :departure_time => "23:17:00" },
        { :trip_id => 2451, :departure_time => "23:17:00" },
        { :trip_id => 2512, :departure_time => "23:32:00" },
        { :trip_id => 2551, :departure_time => "23:32:00" },
        { :trip_id => 2315, :departure_time => "23:42:00" },
        { :trip_id => 2344, :departure_time => "23:42:00" },
        { :trip_id => 2205, :departure_time => "23:44:00" },
        { :trip_id => 2238, :departure_time => "23:44:00" },
        { :trip_id => 2462, :departure_time => "23:53:00" },
        { :trip_id => 2501, :departure_time => "23:53:00" },
        { :trip_id => 2560, :departure_time => "23:57:00" },
        { :trip_id => 2591, :departure_time => "23:57:00" },
        { :trip_id => 2207, :departure_time => "24:29:00" },
        { :trip_id => 2240, :departure_time => "24:29:00" },
        { :trip_id => 2464, :departure_time => "24:39:00" },
        { :trip_id => 2503, :departure_time => "24:39:00" },
        { :trip_id => 2329, :departure_time => "24:42:00" },
        { :trip_id => 2354, :departure_time => "24:42:00" },
        { :trip_id => 2545, :departure_time => "24:42:00" },
        { :trip_id => 2562, :departure_time => "24:42:00" },
        { :trip_id => 2367, :departure_time => "25:06:00" },
        { :trip_id => 2370, :departure_time => "25:26:00" },
        { :trip_id => 2407, :departure_time => "25:26:00" },
        { :trip_id => 2366, :departure_time => "25:38:00" },
        { :trip_id => 2131, :departure_time => "25:42:00" },
        { :trip_id => 2160, :departure_time => "25:42:00" },
        { :trip_id => 2349, :departure_time => "25:42:00" },
        { :trip_id => 2364, :departure_time => "25:42:00" },
        { :trip_id => 2372, :departure_time => "26:06:00" },
        { :trip_id => 2409, :departure_time => "26:06:00" },
        { :trip_id => 2586, :departure_time => "26:06:00" },
        { :trip_id => 2605, :departure_time => "26:06:00" },
        { :trip_id => 2368, :departure_time => "26:22:00" },
        { :trip_id => 2369, :departure_time => "26:58:00" },
        { :trip_id => 2140, :departure_time => "27:07:00" },
        { :trip_id => 2371, :departure_time => "27:56:00" }
      ]

      Time.stubs(:now).returns(DateTime.parse("2011-11-02 18:00:00"))
      assert_equal expected, @feed.next_departures_for_stop(METROPARK)
    end
  end
end
