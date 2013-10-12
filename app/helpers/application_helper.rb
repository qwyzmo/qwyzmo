
module ApplicationHelper

  def logo
    #<% logo = image_tag("twin-galaxies.jpg", :alt => "Sample App", 
    # =>        :class => "round", :width => "200") %>
    return image_tag("twin-galaxies.jpg", :alt => "Qwyzmo", 
                      :class => "round", :width => "200")
  end
  
  
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
