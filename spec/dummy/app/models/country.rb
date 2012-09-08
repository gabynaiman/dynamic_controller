class Country < ActiveRecord::Base
  has_many :cities, dependent: :destroy
  attr_accessible :name
  validates_presence_of :name
end
