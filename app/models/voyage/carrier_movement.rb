class Voyage::CarrierMovement < ApplicationRecord
  belongs_to :arrival_location, class_name: 'Location::Location'
  belongs_to :departure_location, class_name: 'Location::Location'
end
