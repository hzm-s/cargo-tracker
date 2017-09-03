module Location
  UnLocode = Struct.new(:un_locode) do
    def from_string(string)
      new(string)
    end

    def initialize(country_and_location)
      super(country_and_location.upcase)
    end

    def to_s
      un_locode
    end
  end
end
