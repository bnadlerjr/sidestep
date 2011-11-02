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
      trips_for_route = @db[:trips].select(:trip_id).where(:route_id => route_id)
      stops = @db[:stop_times].select(:stop_id).filter(:trip_id => trips_for_route)
      @db[:stops].select(:stop_id, :stop_name).where(:stop_id => stops).order(:stop_name).all
    end
  end
end
