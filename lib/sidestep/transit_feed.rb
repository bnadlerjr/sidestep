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
    # and it's name.
    def routes
      @db[:routes].
        select(:route_id, :route_long_name).
        where(:route_id => routes_for_today).
        order(:route_long_name).
        all
    end

    # Retrieve all stops for a specific +route_id+.
    def stops_for_route(route_id)
      stop_ids = @db[:stop_times].
        select(:stop_id).
        where(:trip_id => trips_for_route_today(route_id))

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
      stop_name = get_stop_name_by_id(stop_id)

      @db[:stop_times].
        join(:trips, :trip_id => :trip_id).
        join(:calendar_dates, :service_id => :service_id).
        where(:date => Date.today.strftime("%Y%m%d")).
        select(:trips__trip_id, :stop_id, :departure_time, :trip_headsign).
        where(:route_id => route_id).
        where(:stop_id => stop_id).
        where{ departure_time > time }.
        where(~{:trip_headsign => stop_name}).
        order(:departure_time).
        all
    end

    # Retrieves the remaining stops for a trip (+trip_id+) and the current stop
    # (+stop_id+).
    def remaining_stops_for_trip(trip_id, stop_id)
      stop_times = @db[:stop_times]
      sequence_id = stop_times.
        select(:stop_sequence).
        where(:trip_id => trip_id, :stop_id => stop_id).
        first[:stop_sequence]

      stop_times.
        join(:stops, :stop_id => :stop_id).
        select(:stop_name, :arrival_time).
        where(:trip_id => trip_id).
        where{ stop_sequence >= sequence_id }.
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

      def routes_for_today
        today = Date.today.strftime("%Y%m%d")
        @db[:trips].
          distinct.
          select(:route_id).
          join(:calendar_dates, :service_id => :service_id).
          where(:date => today).
          map(:route_id)
      end

      def get_stop_name_by_id(stop_id)
        @db[:stops].
          select(:stop_name).
          where(:stop_id => stop_id).
          map(:stop_name).
          first
      end
  end
end
