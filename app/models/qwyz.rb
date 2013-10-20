class Qwyz < ActiveRecord::Base
	attr_accessible :name, :question, :description

	belongs_to :user

	# todo: add validations, like the microposts model has.
	validates :name,			 :presence => true, :length => {:maximum => 100}
	validates :question,	:presence => true, :length => {:maximum => 200}
	validates :user_id,	 :presence => true
	
	default_scope :order => 'qwyzs.created_at DESC'
end
