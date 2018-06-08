module Cargo
  class RoutingStatus < Struct.new(:status)
    NOT_ROUTED = new('not_routed')
    NOT_RECEIVED = new('not_received')
    MISROUTED = new('misrouted')
    ROUTED = new('routed')

    def from_string(str)
      new(str)
    end

    def to_s
      status
    end
  end
end
