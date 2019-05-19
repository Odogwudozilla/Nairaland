# require 'fileutils'
require_relative 'urls_nairaland' # call the class methods in the other file
# require_relative 'nairaland'
# require 'highline/import'
# require_relative 'pdf_generator'
# require 'httparty'
# require 'nokogiri'
# require 'open-uri'
# require 'prawn'
# require 'byebug'

class Kontrol

  def self.prompter

    $chosen_site = ""
    until $chosen_site.include? "https://www.nairaland.com" 
      puts "Please input a nairaland URL"
      sleep(1)
      $chosen_site = ask "Paste the URL/Link from *'nairaland.com'* thread/page you want to scrape: "
      $chosen_site = $chosen_site.gsub(/\A"|\/(?:.(?!\/))+$/, "") #strip away unneeded apostrophes and last forward slash (and everything after) at beginning and end of string
      
    end 

    puts "Thank you for your valid input. Checking database of URLs now..."; sleep(2) 
    
    MyUrls.urls_cache    
    if $urls_list.include? $chosen_site
      puts "This site **>>#{$chosen_site}<<** is already in the list of URLS \n\n "
    else 
      puts "Your chosen site will be added to database \n\n"
    end 
    
    your_try = 0
    while your_try <= 3
      confirm = ask "Do you want to continue?(y/n)"
      if your_try == 3 || confirm.downcase == "n" 
        print "Eiyaa..Exiting...bye..."
        sleep(3)
        puts "done"
        exit
      elsif confirm.downcase == "y"
        puts "Thank you, will now execute your instructions"
        break
      else
        puts "WRONG answer!!! Please try again"
      end  
      your_try += 1
      puts "This is your number #{your_try} try. You have #{3 - your_try} trys left"
    end
    
#next is to check if the site is from nairaland
    

  
  end # end prompter
  
end # end Kontrol

#Kontrol.new.prompter