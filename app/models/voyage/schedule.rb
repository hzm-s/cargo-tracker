module Voyage
  class Schedule < Struct.new(:carrier_movements)
    EMPTY = new([])
  end
end
