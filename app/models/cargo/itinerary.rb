module Cargo
  Itinerary = Struct.new(:legs) do

    def initial_departure_location
      legs.first.load_location
    end

    def final_arrival_location
      last_leg.unload_location
    end

    def final_arrival_date
      last_leg.unload_time
    end

    def last_leg
      legs.last
    end
  end
end
