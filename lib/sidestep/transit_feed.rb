require "sequel"

module Sidestep
  # Interface to Transit Feed data.
  class TransitFeed
    # Initializes a new Transit Feed. +transit_database+ is a handle to a
    # +Sequel+ database.
    def initialize(transit_database)
      @db = transit_database
    end

    # Retrieve all routes. Returns an array of hashes containing the route id
    # and it's name. Any routes where route_long_name is blank are not
    # returned.
    def routes
      @db[:routes].
        select(:route_id, :route_long_name).
        filter(:route_long_name => '').invert.
        order(:route_long_name).
        all
    end

    # Retrieve all stops for a specific +route_id+.
    def stops_for_route(route_id)
      stop_ids = @db[:stop_times].
        select(:stop_id).
        filter(:trip_id => trips_for_route_today(route_id))

      stops = @db[:stops].
        select(:stop_id, :stop_name).
        where(:stop_id => stop_ids).
        order(:stop_name).
        all

      stops.map { |stop| { :route_id => route_id}.merge(stop) }
    end

    # Retrieve next departures for a given stop based on the current time and
    # given route.
    def next_departures_on_route_for_stop(route_id, stop_id)
      time = Time.now.strftime("%H:%M:%S")
      DB[:stop_times].
        join(:trips, :trip_id => :trip_id).
        join(:calendar_dates, :service_id => :service_id).
        filter(:date => Date.today.strftime("%Y%m%d")).
        select(:trips__trip_id, :stop_id, :departure_time, :trip_headsign).
        filter(:route_id => route_id).
        filter(:stop_id => stop_id).
        filter{ departure_time > time }.
        order(:departure_time).
        all
    end

    # Retrieves the remaining stops for a trip (+trip_id+) and the current stop
    # (+stop_id+).
    def remaining_stops_for_trip(trip_id, stop_id)
      stop_times = @db[:stop_times]
      sequence_id = stop_times.
        select(:stop_sequence).
        filter(:trip_id => trip_id, :stop_id => stop_id).
        first[:stop_sequence]

      stop_times.
        join(:stops, :stop_id => :stop_id).
        select(:stop_name, :arrival_time).
        filter(:trip_id => trip_id).
        filter{ stop_sequence >= sequence_id }.
        order(:stop_sequence).
        all
    end

    private
      def trips_for_route_today(route_id)
        today = Date.today.strftime("%Y%m%d")
        @db[:trips].
          select(:trip_id).
          where(:route_id => route_id).
          join(:calendar_dates, :service_id => :service_id).
          where(:date => today)
      end
  end
end
