class MyUrls
  
  def urls_cache
    urls_list = 
          [
            "https://www.nairaland.com/5042902/general-german-student-visa-enquiries/",
            "https://www.nairaland.com/4566903/general-german-student-visa-enquiries",
            "https://www.nairaland.com/5031893/canadian-express-entry-federal-skilled/"
          ]

    return urls_list[1]
    
  end 

end

MyUrls.new.urls_cache