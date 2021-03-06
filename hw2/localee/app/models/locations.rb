class Locations < ActiveRecord::Base

  attr_accessible :latitude, :longitude, :name

  # Validations
  validates :name, :presence => true
  validates :latitude, :presence => true
  validates :longitude, :presence => true

  # Assocations
  has_many :user
  has_many :posts
end
