require 'flux_capacitor/version'
require 'date'
require 'murmurhash3'

module Flux

  class Capacitor
    attr_reader :pivot, :time_dilation
    def initialize (start_time, completion_target, oldest_target = Capacitor.oldest_string_time(start_time))
      @pivot = start_time
      time_to_complete = seconds_between(completion_target, pivot)
      dilation = seconds_between(pivot, oldest_target).to_f / time_to_complete.to_f
      @time_dilation = dilation
    end

    def limit
      diff = seconds_between(DateTime.now, pivot)
      datetime_minus_seconds(pivot, (diff * time_dilation).to_i)
    end

    def travel_to?(destination)
      destination = destination.is_a?(DateTime) ? destination : string_to_time(destination)
      limit < destination
    end

    def string_to_time(str)
      Capacitor.string_to_time(pivot, str)
    end

    def self.string_to_time(pivot, str)
      timestamp  = pivot.strftime("%s").to_i - (MurmurHash3::V32.str_hexdigest(str).to_i(16)/8)
      DateTime.strptime(timestamp.to_s, "%s")
    end

    def self.oldest_string_time(pivot)
      timestamp  = pivot.strftime("%s").to_i - ("ffffffff".to_i(16)/8)
      DateTime.strptime(timestamp.to_s, "%s")
    end

    private

    def seconds_between(date_time_1, date_time_2)
      date_time_1.strftime("%s").to_i - date_time_2.strftime("%s").to_i
    end

    def datetime_minus_seconds(datetime, seconds)
      ts = (datetime.strftime("%s").to_i - seconds).to_s
      DateTime.strptime(ts, "%s")
    end
  end
end