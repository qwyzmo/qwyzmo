class Qwyz < ActiveRecord::Base
	attr_accessor :name, :question, :description

	belongs_to :user

	validates :name,			 :presence => true, :length => {:maximum => 100}
	validates :question,	:presence => true, :length => {:maximum => 200}
	validates :user_id,	 :presence => true
	
	# TODO fix default ordering of qwyzs
	
	# default_scope :order => 'qwyzs.created_at DESC'
	
	

end
