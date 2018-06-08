class Handling::HandlingEvent < ApplicationRecord
  class Type < Struct.new(:type)
    RECEIVE = new('receive')
    LOAD = new('load')
    UNLOAD = new('unload')
    CLAIM = new('claim')
    CUSTOMS = new('customs')

    def self.from_string(str)
      new(str)
    end

    alias_method :to_s, :type
  end

  self.inheritance_column = :_type_disabled

  belongs_to :cargo, class_name: 'Cargo::Cargo', foreign_key: 'cargo_cargo_id'
  belongs_to :voyage, class_name: 'Voyage::Voyage', foreign_key: 'voyage_voyage_id'
  belongs_to :location, class_name: 'Location::Location', foreign_key: 'location_location_id'

  attribute :type, :compatible_with_string, class_name: Handling::HandlingEvent::Type
end
