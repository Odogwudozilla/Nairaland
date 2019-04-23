require 'httparty'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'byebug'

def nairaland

  page_nos = ["0","1"] # set array for page numbers

  page_nos.each do |page_no|
    urle = 'https://www.nairaland.com/5042902/general-german-student-visa-enquiries/' + page_no
      unparsed_page = HTTParty.get(urle)
      parsed_page = Nokogiri::HTML(unparsed_page)
      tmain = parsed_page.css('div.body table tr td')
      thead_all = tmain.css('.bold') #The table headings
      # For the headings
      # thead_all.each do |thead|
      #   thread_topic = thead.css('a[href]').first.text
      #   user_poster = thead.css('a.user').text
      #   post_date = thead.css('span.s').text

      #   puts thread_topic + " " + user_poster + " " + post_date
      # end
      
      tdata_all = tmain.css('.pd') #The table data
      ttext_all = tdata_all.css('div.narrow') #The table text
      tlike_all = tdata_all.css('p.s b[id^="lp"]').text #The table actions 'like' attribute

      tlike_figure = tlike_all.gsub(/\D/, "").to_i #Strip out the alphabets in the variable and converts to integer
      
      
      byebug

  end

end
  
#   page_nos = ["1", "2"] # set array for page numbers
  
#   @scraped_data = []
  
#   page_nos.each do |page_no|
#     # Iterate though the pages and parse the data
#     urle = 'https://www.ukuni.net/universities?page=' + page_no
#     unparsed_page = HTTParty.get(urle)
#     parsed_page = Nokogiri::HTML(unparsed_page)
  
#     links_all = parsed_page.css('div.university-right-conbox-left-thumb a')
    
#     loop_data = []
#     # byebug 
    
#     links_all.each do |link|
#       # iterate through all links to the schools information and parse the data
#       url = 'https://www.ukuni.net' + link.attributes["href"].value + '#tab/3'
#       url2 = 'https://www.ukuni.net' + link.attributes["href"].value + '#tab/0'
#       unparsed_page1 = HTTParty.get(url)
#       unparsed_page2 = HTTParty.get(url2)
#       parsed_page1 = Nokogiri::HTML(unparsed_page1)
#       parsed_page2 = Nokogiri::HTML(unparsed_page2)
      
#       school_name = parsed_page1.css('div.uni-detail-mid-box-bigtitle').text # grab the school name
#       # grab the school description and strip off unwanted information
#       school_desc = parsed_page1.css('div.uni-detail-mid-arti-innbg').text 
#       school_desc1 = school_desc.gsub(/((.)(.*?)(?=About)|(?=Entry)(.*))/, "").gsub(/(About)/, "")
#       # grab the link to the school if present
#       school_link = parsed_page1.css('div.uni-detail-mid-arti-innbg p a').first == nil ? "site link not present" : parsed_page1.css('div.uni-detail-mid-arti-innbg p a').first.attributes["href"]
#       # grab the latitude and longtitude if present
#       school_lat = parsed_page2.css('div.geolocation meta').first == nil ? 0 : parsed_page2.css('div.geolocation meta').first.attributes["content"].value
#       school_long = parsed_page2.css('div.geolocation meta').last == nil ? 0 : parsed_page2.css('div.geolocation meta').last.attributes["content"].value
      
#       # appends schools' data to array
#       loop_data << [
#         school_name,
#         school_desc1,
#         school_lat,
#         school_long,
#         school_link              
#       ]
      
#       puts "***** School \"#{school_name}\" created ******* \n\n"
      
#     end

#     puts "***** Total looped date for this section is \"#{loop_data.count}\" ******* \n\n"

#     # appends the content of the loop to another array
#     @scraped_data << loop_data 
#   end
  
#   # writes the content of the arrays to CSV
#   CSV.open("uk-universities.csv", "w", 
#     :write_headers=> true,
#     :headers => ["school_name","school_description","school_latitude", "school_longtitude", "school_link"]) do |csv|
#       @scraped_data.each do |prit|
#         prit.each do |rit|
#           csv << rit
#         end
        
#       end 
#   end

#   puts "***** Total scrapped data is \"#{@scraped_data[0].count + @scraped_data[1].count}\" ******* \n\n"

# end


nairaland