require_relative 'urls_nairaland' # call the class methods in the other file
require_relative 'pdf_generator'
require 'httparty'
require 'nokogiri'
require 'open-uri'
require 'prawn'
require 'byebug'

class SiteScraper

  def nairaland
    $printed_on =Time.now # Define the current date-time
  
    #Defining the page numbers in order to iterate through it
    page_nos = []
    $url = MyUrls.urls_cache #grab the URL from the list on MyUrls class
    unparsed_page1 = HTTParty.get($url)  
    parsed_page1 = Nokogiri::HTML(unparsed_page1)
    
    tpages = parsed_page1.css('div.body div.nocopy a[href]')
    $page_title = parsed_page1.css('div.body p.bold a[href]').last.text.gsub(/(\/|\\)/, " - ")
  
    pages_arr = [] #Open an array of pages
    tpages.each do |tpage|
      next if tpage.text.nil? #skip if nil
      pages_arr << tpage.text.gsub(/\D/, "") #using regex to eliminate non-digits and pushing into array
    end # end tpages
    pages_arr = pages_arr.reject(&:empty?).sort_by(&:to_i).reverse # eliminate empty/blank values in array, converting to integer an sorting in descending order
    puts "The page array is #{pages_arr}"
    
    # picking the first or second array element as the highest page (still trying to figure out how to make this cleaner as a strange number keeps intermittently showing up as first array element. So I assume the thread page cannot go above 800 pages before the thread is closed)
     
    highest_page = pages_arr[0].to_i > 800 ? pages_arr[1].to_i : pages_arr[0].to_i
     
    puts "The highest page in this session is #{highest_page}"
    
    
    page_nos = *(0..highest_page) # set array range for page numbers to loop through
  
  
    head_data = [] # set empty array to collate table heading data on each page
    post_data =[] # set empty array to collate table body data on each page
    
    #Iterating through the page numbers
    page_nos.each do |page_no|
  
      urle = $url + page_no.to_s
      unparsed_page = HTTParty.get(urle)
      parsed_page = Nokogiri::HTML(unparsed_page)
      
      
      tmain = parsed_page.css('div.body table tr td')
      
      thead_all = tmain.css('.pu') #The table headings
      
      thead_all.each do |thead|
        thread_topic = thead.css('a[href]').text
        linke = thead.css('a[href*="#"]')[0],
        user_poster = thead.css('a.user').text
        post_date = thead.css('span.s').text
        
        # push head_data to array
        head_data << {:topic => thread_topic,
          :username => user_poster,
          # :topic_link => linke[0].attribute("href") == nil ? "dead link" : linke[0].attribute("href").value,
          :date => post_date}
          # byebug
      end # end head_data
      
      # begin
      # rescue => exception
      #   puts exception
      #   puts exception.backtrace
      #   #byebug
      # end
        # byebug
        
      pdata_all = tmain.css('.pd') #The table data
        
        
      pdata_all.each do |pdata|
          
          ptext = pdata.css('div.narrow').inner_html #The table text
          plike = pdata.css('p.s b[id^="lp"]').text #The table actions 'like' attribute
          plike_figure = plike.gsub(/\D/, "") #Strip out the alphabets in the variable and converts to integer
          
          #push post_data to array
          post_data << {:post_text => ptext,
            :post_likes => plike_figure.to_i,
            :page_number => page_no
          }
          
      end # end pdata_all

      puts "************Data for page #{page_no} added. Total headings = #{thead_all.count} while total bodytext = #{pdata_all.count}************"
      
    end
    # byebug
    
    combined_data = head_data.zip(post_data).to_h # Combine both headings data and body data into a hash of arrays
    
    $combined_data_rank = combined_data.sort_by{ |key, value| value[:post_likes] }.reverse.take(50) # sort and rank the combined data hash by the number of likes for each post and then take only the top 50
    
    GenPdf.gen_pdf
    
    puts "$$*************Process completed and PDF '#{@page_title}.pdf' created************$$"
    #byebug
    
  end

end 


SiteScraper.new.nairaland