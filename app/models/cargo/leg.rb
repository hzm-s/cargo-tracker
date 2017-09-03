class Cargo::Leg < ApplicationRecord
  belongs_to :voyage, class_name: 'Voyage::Voyage', foreign_key: 'voyage_voyage_id'
  belongs_to :load_location, class_name: 'Location::Location'
  belongs_to :unload_location, class_name: 'Location::Location'
end
