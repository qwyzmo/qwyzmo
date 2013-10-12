class Qwyz < ActiveRecord::Base
  attr_accessible :name, :question, :description
  
  belongs_to :user
  
  # todo: add validations, like microposts
end
