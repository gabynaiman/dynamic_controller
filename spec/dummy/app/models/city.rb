class City < ActiveRecord::Base
  belongs_to :country
  has_many :streets, dependent: :destroy
  attr_accessible :country_id, :name
  validates_presence_of :country_id, :name
end
