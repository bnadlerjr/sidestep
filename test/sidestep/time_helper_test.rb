require "test_helper"
require "sidestep/time_helper"

module Sidestep
  class TimeHelperTest < Test::Unit::TestCase
    setup do
      @stub = stub.extend(Sidestep::TimeHelper)
    end

    test "converts transit times after midnight" do
      expected = ["00:15:00", "01:20:00", "02:25:00"]

      times = ["24:15:00", "25:20:00", "26:25:00"]
      actual = times.map { |t| @stub.convert_transit_time(t) }

      assert_equal expected, actual
    end

    test "does not convert transit times before midnight" do
      expected = ["21:15:00", "22:20:00", "23:25:00"]
      actual = expected.map { |t| @stub.convert_transit_time(t) }

      assert_equal expected, actual
    end
  end
end
