class Location::Location < ApplicationRecord

  def same_identity_as(other)
    un_locode == other.un_locode
  end
end
