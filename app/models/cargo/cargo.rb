module Cargo
  class Cargo < ApplicationRecord
    attr_accessor :route_specification
    attr_accessor :itinerary
    attr_accessor :delivery

    belongs_to :origin, class_name: 'Location::Location'

    after_initialize do
      self.origin = route_specification.origin
      self.delivery =
        Delivery.derived_from(
          route_specification,
          itinerary,
          Handling::HandlingHistory::EMPTY
        )
    end

    def specify_new_route(routing_specification)
      self.route_specification = routing_specification
      self.delivery = delivery.update_on_routing(self.route_specification, itinerary)
    end

    def assign_to_route(itinerary)
      self.itinerary = itinerary
      self.delivery = delivery.update_on_routing(route_specification, itinerary)
    end

    def derive_delivery_progress(handling_history)
      self.delivery =
        Delivery.derived_from(
          route_specification,
          itinerary,
          handling_history
        )
    end

    def ==(other)
      return true if self.equal?(other)
      other.instance_of?(self.class) && same_identity_as(other)
    end

    def same_identity_as(other)
      other && tracking_id == other.tracking_id
    end
  end
end
