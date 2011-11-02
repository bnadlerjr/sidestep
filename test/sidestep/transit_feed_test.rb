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
  end
end
