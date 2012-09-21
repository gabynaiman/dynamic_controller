class Street < ActiveRecord::Base
  belongs_to :city
  attr_accessible :city_id, :name
  validates_presence_of :city_id, :name
end
