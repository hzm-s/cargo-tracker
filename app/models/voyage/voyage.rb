module Voyage
  class Voyage < ApplicationRecord
    attr_accessor :schedule

    NONE = new(voyage_number: VoyageNumber.new(''), schedule: Schedule::EMPTY)
  end

  class Voyage
    class Builder

      def initialize(voyage_number, departure_location)
        @voyage_number = voyage_number
        @departure_location = departure_location
        @carrier_movements = []
      end

      def add_movement(arrival_location, departure_time, arrival_time)
        carrier_movement =
          CarrierMovement.new(
            departure_location: @departure_location,
            arrival_location: arrival_location,
            departure_time: departure_time,
            arrival_time: arrival_time
          )
        @carrier_movements << carrier_movement
        @departure_location = arrival_location
        self
      end

      def build
        Voyage.new(
          voyage_number: @voyage_number,
          schedule: Schedule.new(@carrier_movements)
        )
      end
    end
  end
end
