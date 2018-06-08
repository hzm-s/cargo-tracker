module Cargo
  class TransportStatus < Struct.new(:status)
    NOT_RECEIVED = new('not_received')
    IN_PORT = new('in_port')
    ONBOARD_CARRIER = new('onboard_carrier')
    CLAIMED = new('claimed')
    UNKNOWN = new('unknown')
  end
end
