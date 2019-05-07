class MyUrls
  
  def self.urls_cache
    
    $urls_list = File.readlines("urls_nairaland.txt")
    $urls_list = $urls_list.each { |u| u.delete!("\\\n")}
          # [
          #   "https://www.nairaland.com/5042902/general-german-student-visa-enquiries/",
          #   "https://www.nairaland.com/4566903/general-german-student-visa-enquiries",
          #   "https://www.nairaland.com/5031893/canadian-express-entry-federal-skilled/"
          # ]

    #return urls_list[0]
    puts $urls_list
  end 

end

# MyUrls.urls_cache
#{ |url| url.each { |u| u.delete!("\n")} }