class CargoBookingsController < ApplicationController

  def new
    @form = NewCargoBookingForm.new
  end
end
