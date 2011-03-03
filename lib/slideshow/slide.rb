module Slideshow

  class Slide < Struct.new(:header, :content, :classes, :transition)
  
    def to_classic_html
       
      buf  = ""
      buf << "<div class='slide "
      buf << classes    if classes
      buf << "'>\n"      
      
      buf << header     if header
      buf << content    if content
      
      buf << "</div>\n"
      buf       
    end
    
    def to_google_html5
      
      buf  = ""
      case transition
      when nil?
        buf << "<div class='slide'>\n"
      when /^([a-zA-Z_-]+)-title$/
        buf << "<div class='slide transitionSlide' id='#{$1}-title'>\n"
      when /^([a-zA-Z_-]+)\[(\d+)\]$/
        buf << "<div class='slide #{$1}' id='#{$1}-#{$2}'>\n"
      else
        buf << "<div class='slide #{transition}'>\n"
      end

      if header
        buf << "<header>#{header}</header>\n"
      end
      
      buf << "<section class='"
      buf << classes      if classes      
      buf << "'>\n"
      
      buf << content      if content
      buf << "</section>\n"
      buf << "</div>\n"
      buf
    end
  
  end # class slide

end # module Slideshow