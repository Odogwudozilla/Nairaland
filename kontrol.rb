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


    $chosen_site = ask "Paste the URL/Link from *'nairaland.com'* thread/page you want to scrape: "
    $chosen_site = $chosen_site.gsub(/\A"|(\/")|\/\z|\\n/, "") #strip away unneeded apostrophes and forward slashes at beginning and end of string
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
        print "Exiting...bye..."
        sleep(3)
        puts "done"
        exit
      elsif confirm.downcase == "y"
        puts "Thank you, will no execute your instructions"
        break
      else
        puts "please try again"
      end  
      your_try += 1
      puts "This is your number #{your_try} try. You have #{3 - your_try} trys left"
    end
    

    

  
  end # end prompter
  
end # end Kontrol

#Kontrol.new.prompter