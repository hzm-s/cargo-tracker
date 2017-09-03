module Handling
  class HandlingHistory < Struct.new(:handling_events)
    EMPTY = new([])

    def most_recently_completed_event
      handling_events.last
    end
  end
end
