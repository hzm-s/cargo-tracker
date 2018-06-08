module Cargo
  Delivery = Struct.new(
    :calculated_at, :last_event, :misdirected, :routing_status, :transport_status, :last_known_location,
    :current_voyage, :eta, :next_expected_activity, :unloaded_at_destination
  ) do
    class << self

      def derived_from(route_specification, itinerary, handling_history)
        last_event = handling_history.most_recently_completed_event
        new(last_event, itinerary, route_specification)
      end
    end

    def initialize(last_event, itinerary, route_specification)
      super()

      self.calculated_at = Time.current
      self.last_event = last_event

      self.misdirected = calculate_misdirection_status(itinerary)
      self.routing_status = calculate_routing_status(itinerary, route_specification)
      self.transport_status = calculate_transport_status
      self.last_known_location = calculate_last_known_location
      self.current_voyage = calculate_current_voyage
    end

    def update_on_routing(route_specification, itinerary)
      self.class.new(last_event, itinerary, route_specification)
    end

    def misdirected?
      misdirected
    end

    private

      def calculate_misdirection_status(itinerary)
        return false unless last_event
        !itinerary&.expected?(last_event)
      end

      def calculate_routing_status(itinerary, route_specification)
        return RoutingStatus::NOT_ROUTED unless itinerary
        return RoutingStatus::MISROUTED unless route_specification.satisfied_by?(itinerary)
        RoutingStatus::ROUTED
      end

      def calculate_transport_status
        return RoutingStatus::NOT_RECEIVED if last_event.nil?
      end

      def calculate_last_known_location
        return Location::Location::UNKNOWN unless last_event
        last_event.location
      end

      def calculate_current_voyage
        return last_event.voyage if last_event && transport_status == TransportStatus::ONBOARD_CARRIER
        Voyage::Voyage::NONE
      end
  end
end
