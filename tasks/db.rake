require "text_ferry"

namespace :db do
  desc "Load data from GTFS CSV files into database."
  task :load do
    path = File.join(File.dirname(__FILE__), "..", "db")
    puts path
    loader = TextFerry::Loader.new("sqlite://#{path}/transit_data.db", path)

    loader.load_table(:routes) do
      primary_key :route_id
      Integer :agency_id
      String :route_short_name
      String :route_long_name
      String :route_type
      String :route_url
      String :route_color
    end

    loader.load_table(:calendar_dates) do
      Integer :service_id
      String :date
      Integer :exception_type
    end

    loader.load_table(:trips) do
      foreign_key :route_id, :routes
      Integer :service_id
      primary_key :trip_id
      String :trip_headsign
      Integer :direction_id
      Integer :block_id
      Integer :shape_id
    end

    loader.load_table(:stops) do
      primary_key :stop_id
      String :stop_name
      String :stop_desc
      String :stop_lat
      String :stop_lon
      Integer :zone_id
    end

    loader.load_table(:stop_times) do
      foreign_key :trip_id
      String :arrival_time
      String :departure_time
      foreign_key :stop_id
      Integer :stop_sequence
      String :pickup_type
      String :drop_off_type
      String :shape_distance_travelled
    end
  end
end
