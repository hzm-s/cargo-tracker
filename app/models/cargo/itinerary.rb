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

    def expected?(event)
      return true if legs.empty?

      if event.type.equal?(Handling::HandlingEvent::Type::RECEIVE)
        return legs.first.load_location == event.location
      end

      if event.type.equal?(Handling::HandlingEvent::Type::LOAD)
        detected =
          legs.detect do |leg|
            leg.load_location.same_identity_as(event.location) &&
              leg.voyage.same_identity_as(event.voyage)
          end
        return !!detected
      end

      if event.type.equal?(Handling::HandlingEvent::Type::UNLOAD)
        detected =
          legs.detect do
            leg.unload_location == event.location &&
              leg.voyage == event.voyage
          end
        return !!detected
      end

      if event.type.equal?(Handling::HandlingEvent::Type::CLAIM)
        return last_leg.unload_location == event.location
      end

      true
    end
  end
end
