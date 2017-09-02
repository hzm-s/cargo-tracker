class NewCargoBookingForm
  include ActiveModel::Model

  attr_accessor :origin, :destination, :arrival_deadline
end
