module Cargo
  RouteSpecification = Struct.new(:origin, :destination, :arrival_deadline) do

    def satisfied_by?(itinerary)
      itinerary &&
        origin.same_identity_as(itinerary.initial_departure_location) &&
        destination.same_identity_as(itinerary.final_arrival_location) &&
        arrival_deadline >= itinerary.final_arrival_date
    end
  end
end
