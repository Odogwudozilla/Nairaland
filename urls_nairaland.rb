class MyUrls
  
  def self.urls_cache
    
    $urls_list = File.readlines("urls_nairaland.txt")
    $urls_list = $urls_list.each { |u| u.delete!("\\\n")}

    puts "These are the current sites in the database:"
    puts $urls_list
  end 

end

