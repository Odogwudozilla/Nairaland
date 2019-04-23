require 'httparty'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'byebug'

def nairaland
  
  page_nos = []
  url = 'https://www.nairaland.com/5042902/general-german-student-visa-enquiries/'
  unparsed_page1 = HTTParty.get(url)
  parsed_page1 = Nokogiri::HTML(unparsed_page1)
  
  tpages = parsed_page1.css('div.body div.nocopy a[href]')

  pages_arr = []
  tpages.each do |tpage|
    next if tpage.text.nil?
    pages_arr << tpage.text.gsub(/\D/, "")
    end 
  pages_arr = pages_arr.reject(&:empty?).sort_by(&:to_i).reverse

  highest_page = pages_arr[1].to_i
  
  
  page_nos = *(0..highest_page) # set array range for page numbers

  # heading = []
  # body_data = []
  head_data = []
  post_data =[]
  
  page_nos.each do |page_no|
    urle = 'https://www.nairaland.com/5042902/general-german-student-visa-enquiries/' + page_no.to_s
    unparsed_page = HTTParty.get(urle)
    parsed_page = Nokogiri::HTML(unparsed_page)
    
    
    tmain = parsed_page.css('div.body table tr td')
    
    thead_all = tmain.css('.bold') #The table headings
    
    
    thead_all.each do |thead|
      thread_topic = thead.css('a[href]').first.text
      user_poster = thead.css('a.user').text
      post_date = thead.css('span.s').text
      
      head_data << {:topic => thread_topic,
        :username => user_poster,
        :date => post_date}
        
      end
      
      
      pdata_all = tmain.css('.pd') #The table data
      
      
      pdata_all.each do |pdata|
        
        ptext = pdata.css('div.narrow').text #The table text
        plike = pdata.css('p.s b[id^="lp"]').text #The table actions 'like' attribute
        plike_figure = plike.gsub(/\D/, "") #Strip out the alphabets in the variable and converts to integer
        
        post_data << {:post_text => ptext,
          :post_likes => plike_figure.to_i
        }
        
      end 
      
      # heading << head_data
      # body_data << post_data
      
  end
  
  combined_data = head_data.zip(post_data).to_h
  
  combined_data_rank = combined_data.sort_by{ |key, value| value[:post_likes] }.reverse.take(20)
  
  combined_data_rank.each do |key,val|
    puts "Topic: #{key[:topic]} \n
    Posted by #{key[:username]}, #{key[:date]} \n
    Message: \n
    #{val[:post_text]}. \n
    Number of likes: #{val[:post_likes]} \n\n\n\n\n"
    
  end
  
  byebug
  
end


nairaland