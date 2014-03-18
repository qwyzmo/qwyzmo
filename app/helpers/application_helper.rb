
module ApplicationHelper

	# return a title on a per-page basis
	def title
		base_title = "Qwyzmo"
		if @title.nil? 
			return base_title
		else 
			"#{base_title} | #{@title}"
		end
	end
	
end
