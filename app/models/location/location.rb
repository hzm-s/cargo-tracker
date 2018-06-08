class Location::Location < ApplicationRecord
  UNKNOWN = new(un_locode: UnLocode.new('XXXXX'), name: 'Unknown location')

  def same_identity_as(other)
    un_locode == other.un_locode
  end
end
