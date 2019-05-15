# require 'fileutils'
# require_relative 'urls_nairaland' # call the class methods in the other file
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


    $user_input = ask "Paste the URL/Link from *'nairaland.com'* thread/page you want to scrape: "
    $user_input = $user_input.gsub(/\A"|(\/")|\/\z|\\n/, "") #strip away unneeded apostrophes and forward slashes at beginning and end of string
    
    #confirm = ask "your link is **>>#{$user_input}<<**, do you want to continue?(y/n)"



    

  
  end # end prompter
  
end # end Kontrol

#Kontrol.new.prompter