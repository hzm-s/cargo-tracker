require 'rails_helper'

describe Cargo::RouteSpecification do
  let(:hong_kong__tokyo__new_york) do
    Voyage::Voyage::Builder
      .new(Voyage::VoyageNumber.new('V001'), HONGKONG)
      .add_movement(TOKYO, Date.new(2017,2,1), Date.new(2017,2,5))
      .add_movement(NEWYORK, Date.new(2017,2,6), Date.new(2017,2,10))
      .add_movement(HONGKONG, Date.new(2017,2,11), Date.new(2017,2,14))
      .build
  end

  let(:dallas__new_york__chicago) do
    Voyage::Voyage::Builder
      .new(Voyage::VoyageNumber.new('V002'), DALLAS)
      .add_movement(NEWYORK, Date.new(2017,2,6), Date.new(2017,2,7))
      .add_movement(CHICAGO, Date.new(2017,2,12), Date.new(2017,2,20))
      .build
  end

  let(:itinerary) do
    Cargo::Itinerary.new(
      [
        Cargo::Leg.new(
          voyage: hong_kong__tokyo__new_york,
          load_location: HONGKONG,
          unload_location: NEWYORK,
          load_time: Date.new(2017,2,1),
          unload_time: Date.new(2017,2,10)
        ),
        Cargo::Leg.new(
          voyage: dallas__new_york__chicago,
          load_location: DALLAS,
          unload_location: CHICAGO,
          load_time: Date.new(2017,2,12),
          unload_time: Date.new(2017,2,20)
        )
      ]
    )
  end

  it do
    route_specification =
      Cargo::RouteSpecification.new(HONGKONG, CHICAGO, Date.new(2017,3,1))
    expect(route_specification).to be_satisfied_by(itinerary)
  end

  it do
    route_specification =
      Cargo::RouteSpecification.new(HANGZOU, CHICAGO, Date.new(2017,3,1))
    expect(route_specification).to_not be_satisfied_by(itinerary)
  end

  it do
    route_specification =
      Cargo::RouteSpecification.new(HONGKONG, DALLAS, Date.new(2017,3,1))
    expect(route_specification).to_not be_satisfied_by(itinerary)
  end

  it do
    route_specification =
      Cargo::RouteSpecification.new(HONGKONG, CHICAGO, Date.new(2017,2,15))
    expect(route_specification).to_not be_satisfied_by(itinerary)
  end
end
