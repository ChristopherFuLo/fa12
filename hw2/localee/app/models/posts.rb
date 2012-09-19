class Posts < ActiveRecord::Base
  attr_accessible :content

  # Validations
  validates :content, :presence => true

  #Associations
  belongs_to :user
  belongs_to :locations
end
