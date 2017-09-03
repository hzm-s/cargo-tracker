require 'rails_helper'

describe Cargo::Cargo do
  let(:voyage) do
    Voyage::Voyage::Builder
      .new(Voyage::VoyageNumber.new('V123'), STOCKHOLM)
      .add_movement(HAMBURG, Date.today, Date.today)
      .add_movement(HONGKONG, Date.today, Date.today)
      .add_movement(MELBOURNE, Date.today, Date.today)
      .build
  end

  let(:tracking_id) { Cargo::TrackingId.new('XYZ') }
  let(:route_specification) { Cargo::RouteSpecification.new(STOCKHOLM, MELBOURNE, Date.today) }

  describe '.new' do
    it do
      arrival_deadline = Date.new(2017,3,13)
      cargo = Cargo::Cargo.new(tracking_id: tracking_id, route_specification: route_specification)

      expect(cargo.delivery.routing_status).to eq(Cargo::RoutingStatus::NOT_ROUTED)
      expect(cargo.delivery.transport_status).to eq(Cargo::RoutingStatus::NOT_RECEIVED)
      expect(cargo.delivery.last_known_location).to eq(Location::Location::UNKNOWN)
      expect(cargo.delivery.current_voyage).to eq(Voyage::Voyage::NONE)
    end
  end

  describe 'routing status' do
    it do
      cargo = Cargo::Cargo.new(tracking_id: tracking_id, route_specification: route_specification)
      good = Cargo::Itinerary.new
      bad = Cargo::Itinerary.new
      accept_only_good =
        Cargo::RouteSpecification.new(
          cargo.origin,
          cargo.route_specification.destination,
          Date.today
        )
      allow(accept_only_good).to receive(:satisfied_by?) do |itinerary|
        itinerary.equal?(good)
      end

      cargo.specify_new_route(accept_only_good)
      expect(cargo.delivery.routing_status).to eq(Cargo::RoutingStatus::NOT_ROUTED)

      cargo.assign_to_route(bad)
      expect(cargo.delivery.routing_status).to eq(Cargo::RoutingStatus::MISROUTED)

      cargo.assign_to_route(good)
      expect(cargo.delivery.routing_status).to eq(Cargo::RoutingStatus::ROUTED)
    end
  end

  describe 'last known location' do
    it do
      cargo = Cargo::Cargo.new(tracking_id: tracking_id, route_specification: route_specification)
      expect(cargo.delivery.last_known_location).to eq(Location::Location::UNKNOWN)
    end

    it do
      cargo = Cargo::Cargo.new(tracking_id: tracking_id, route_specification: route_specification)
      events = []
      events << build_handling_event(cargo, voyage, Date.new(2017,12,1), :RECEIVE, STOCKHOLM)
      cargo.derive_delivery_progress(Handling::HandlingHistory.new(events))
      expect(cargo.delivery.last_known_location).to eq(STOCKHOLM)
    end

    it do
      cargo = Cargo::Cargo.new(tracking_id: tracking_id, route_specification: route_specification)
      events = []
      events << build_handling_event(cargo, voyage, Date.new(2017,12,1), :LOAD, STOCKHOLM)
      events << build_handling_event(cargo, voyage, Date.new(2017,12,2), :UNLOAD, HAMBURG)
      events << build_handling_event(cargo, voyage, Date.new(2017,12,3), :LOAD, HAMBURG)
      events << build_handling_event(cargo, voyage, Date.new(2017,12,4), :UNLOAD, HONGKONG)
      events << build_handling_event(cargo, voyage, Date.new(2017,12,5), :LOAD, HONGKONG)
      events << build_handling_event(cargo, voyage, Date.new(2017,12,7), :UNLOAD, MELBOURNE)
      cargo.derive_delivery_progress(Handling::HandlingHistory.new(events))
      expect(cargo.delivery.last_known_location).to eq(MELBOURNE)
    end

    it do
      cargo = Cargo::Cargo.new(tracking_id: tracking_id, route_specification: route_specification)
      events = []
      events << build_handling_event(cargo, voyage, Date.new(2017,12,1), :LOAD, STOCKHOLM)
      events << build_handling_event(cargo, voyage, Date.new(2017,12,2), :UNLOAD, HAMBURG)
      events << build_handling_event(cargo, voyage, Date.new(2017,12,3), :LOAD, HAMBURG)
      events << build_handling_event(cargo, voyage, Date.new(2017,12,4), :UNLOAD, HONGKONG)
      cargo.derive_delivery_progress(Handling::HandlingHistory.new(events))
      expect(cargo.delivery.last_known_location).to eq(HONGKONG)
    end

    it do
      cargo = Cargo::Cargo.new(tracking_id: tracking_id, route_specification: route_specification)
      events = []
      events << build_handling_event(cargo, voyage, Date.new(2017,12,1), :LOAD, STOCKHOLM)
      events << build_handling_event(cargo, voyage, Date.new(2017,12,2), :UNLOAD, HAMBURG)
      events << build_handling_event(cargo, voyage, Date.new(2017,12,3), :LOAD, HAMBURG)
      cargo.derive_delivery_progress(Handling::HandlingHistory.new(events))
      expect(cargo.delivery.last_known_location).to eq(HAMBURG)
    end
  end

  describe 'equality' do
    it do
      spec1 = Cargo::RouteSpecification.new(STOCKHOLM, HONGKONG, Date.today)
      spec2 = Cargo::RouteSpecification.new(STOCKHOLM, MELBOURNE, Date.today)
      cargo1 = Cargo::Cargo.new(tracking_id: Cargo::TrackingId.new('ABC'), route_specification: spec1)
      cargo2 = Cargo::Cargo.new(tracking_id: Cargo::TrackingId.new('CBA'), route_specification: spec1)
      cargo3 = Cargo::Cargo.new(tracking_id: Cargo::TrackingId.new('ABC'), route_specification: spec2)
      cargo4 = Cargo::Cargo.new(tracking_id: Cargo::TrackingId.new('ABC'), route_specification: spec1)

      expect(cargo1).to eq(cargo4)
      expect(cargo1).to eq(cargo3)
      expect(cargo3).to eq(cargo4)
      expect(cargo1).to_not eq(cargo2)
    end
  end

  describe 'unloaded final destination' do
    it do
      events = []

      cargo = build_cargo_with_itinerary
      expect(cargo.delivery).to_not be_misdirected

      # Happy path
      handling_events = []
      handling_events << build_handling_event(cargo, voyage, 1.day.since, :RECEIVE, SHANGHAI)
      handling_events << build_handling_event(cargo, voyage, 3.days.since, :LOAD, SHANGHAI)
      handling_events << build_handling_event(cargo, voyage, 5.days.since, :UNLOAD, ROTTERDAM)
      handling_events << build_handling_event(cargo, voyage, 7.days.since, :LOAD, ROTTERDAM)
      handling_events << build_handling_event(cargo, voyage, 9.days.since, :UNLOAD, GOTHENBURG)
      handling_events << build_handling_event(cargo, voyage, 11.days.since, :CLAIM, GOTHENBURG)
      handling_events << build_handling_event(cargo, voyage, 13.days.since, :CUSTOMS, GOTHENBURG)

      events += handling_events
      cargo.derive_delivery_progress(Handling::HandlingHistory.new(events))
      expect(cargo.delivery).to_not be_misdirected

      # Failing 1
      cargo = build_cargo_with_itinerary
      handling_events = []
      handling_events << build_handling_event(cargo, voyage, 1.day.since, :RECEIVE, HANGZOU)

      events += handling_events
      cargo.derive_delivery_progress(Handling::HandlingHistory.new(events))
      expect(cargo.delivery).to be_misdirected

      # Failing 2
      cargo = build_cargo_with_itinerary
      handling_events = []
      handling_events << build_handling_event(cargo, voyage, 1.day.since, :RECEIVE, SHANGHAI)
      handling_events << build_handling_event(cargo, voyage, 3.days.since, :LOAD, SHANGHAI)
      handling_events << build_handling_event(cargo, voyage, 5.days.since, :UNLOAD, ROTTERDAM)
      handling_events << build_handling_event(cargo, voyage, 7.days.since, :CLAIM, ROTTERDAM)

      events += handling_events
      cargo.derive_delivery_progress(Handling::HandlingHistory.new(events))
      expect(cargo.delivery).to be_misdirected
    end
  end

  private

    def build_handling_event(cargo, voyage, completion_time, type, location)
      Handling::HandlingEvent.new(
        cargo: cargo,
        completion_time: completion_time,
        registration_time: completion_time,
        type: Handling::HandlingEvent::Type.const_get(type),
        location: location,
        voyage: voyage
      )
    end

    def build_cargo_with_itinerary
      tracking_id = Cargo::TrackingId.new('CARG01')
      route_specification = Cargo::RouteSpecification.new(SHANGHAI, GOTHENBURG, Date.today)

      cargo = Cargo::Cargo.new(tracking_id: tracking_id, route_specification: route_specification)
      itinerary = Cargo::Itinerary.new(
        [
          Cargo::Leg.new(voyage: voyage, load_location: SHANGHAI, unload_location: ROTTERDAM, load_time: Date.today, unload_time: Date.today),
          Cargo::Leg.new(voyage: voyage, load_location: ROTTERDAM, unload_location: GOTHENBURG, load_time: Date.today, unload_time: Date.today),
        ]
      )
      cargo.assign_to_route(itinerary)
      cargo
    end
end
