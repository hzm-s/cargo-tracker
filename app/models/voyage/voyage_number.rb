module Voyage
  VoyageNumber = Struct.new(:number) do
    def self.from_string(string)
      new(string)
    end

    def to_s
      number
    end
  end
end
