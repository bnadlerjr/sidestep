module Sidestep
  module TimeHelper
    # Transit times that occur after midnight are not 'rolled over', this
    # method fixes that.
    #
    # Example::
    # convert_transit_time("25:15:00") => "01:15:00"
    def convert_transit_time(time)
      parts = time.split(':')
      hour = parts[0].to_i

      return time if hour < 24

      parts[0] = hour - 24
      '0' + parts.join(':')
    end
  end
end
