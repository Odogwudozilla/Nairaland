require_relative 'urls_nairaland' # call the class methods in the other file
# require_relative 'pdf_generator'
require 'httparty'
require 'nokogiri'
require 'open-uri'
require 'prawn'
require 'byebug'

class SiteScraper

  def nairaland
    printed_on =Time.now 
  
    #Defining the page numbers in order to iterate through it
    page_nos = []
    url = MyUrls.new.urls_cache
    unparsed_page1 = HTTParty.get(url)
    parsed_page1 = Nokogiri::HTML(unparsed_page1)
    
    tpages = parsed_page1.css('div.body div.nocopy a[href]')
  
    pages_arr = [] #Open an array of pages
    tpages.each do |tpage|
      next if tpage.text.nil? #skip if nil
      pages_arr << tpage.text.gsub(/\D/, "") #using regex to eliminate non-digits and pushing into array
      end 
    pages_arr = pages_arr.reject(&:empty?).sort_by(&:to_i).reverse # eliminate empty/blank values in array, converting to integer an sorting in descending order
    puts "The page array is #{pages_arr}"
    
    # picking the first or second array element as the highest page (still trying to figure out how to make this cleaner as a strange number keeps intermittently showing up as first array element. So I assume the thread page cannot go above 800 pages before the thread is closed)
    if pages_arr[0].to_i > 800
      highest_page = pages_arr[1].to_i 
    else
      highest_page = pages_arr[0].to_i
    end 
    puts "The highest page in this session is #{highest_page}"
    
    
    page_nos = *(0..highest_page) # set array range for page numbers to loop through
  
  
    head_data = [] # set empty array to collate table heading data on each page
    post_data =[] # set empty array to collate table body data on each page
    
    #Iterating through the page numbers
    page_nos.each do |page_no|
  
      urle = url + page_no.to_s
      unparsed_page = HTTParty.get(urle)
      parsed_page = Nokogiri::HTML(unparsed_page)
      
      
      tmain = parsed_page.css('div.body table tr td')
      @page_title = parsed_page.css('div.body p.bold a[href]').last.text.gsub(/(\/|\\)/, " - ")
      
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
            :post_likes => plike_figure.to_i,
            :page_number => page_no
          }
          
        end 
        puts "************data for page #{page_no} added ************"
        
    end
    
    combined_data = head_data.zip(post_data).to_h # Combine both headings data and body data into a hash of arrays
    
    combined_data_rank = combined_data.sort_by{ |key, value| value[:post_likes] }.reverse.take(50) # sort and rank the combined data hash by the number of likes for each post and then take only the top 50
    
 # output the result to PDF file
        Prawn::Document.generate("#{@page_title}.pdf") do
          font_families.update("Roboto"=>{:normal =>"fonts/Roboto/Roboto-Regular.ttf"}, "OpenSans"=>{:normal =>"fonts/Open_Sans/OpenSans-Regular.ttf"})
          combined_data_rank.each do |key,val|
            
            font "OpenSans"
            default_leading 5
            font_size(18) {text "#{key[:topic]} \n", :color => "0000FF"}
            font_size(9) {text "Posted (on page <color rgb='FF00FF'>#{val[:page_number]}</color>) by:", :inline_format => true} 
            font_size(14) {text "#{key[:username]}", :color => "FF0000"} 
            font_size(9) {text "#{key[:date]} \n"} 
            move_down 10
            font_size(12) {text "Message:", :color => "FF00FF"}
            font_size(14) {text "#{val[:post_text]}. \n", :align => :justify, :indent_paragraphs => 20} 
            font "Roboto"
            text "Number of likes: <color rgb='0000FF'> #{val[:post_likes]}</color>", :inline_format => true
            # Configure the horizontal line
            stroke_color "24292E"
            x = 100
            y = 400
            7.times do 
      
              stroke do
                horizontal_line x, y
              end
      
              x += 20
              y -= 20
              move_down 5
            end 
      
            start_new_page
      
          end
      
          move_down 30
          font_size(9) {text "Data scrapped from <color rgb='0000FF'>#{url}</color>, <color rgb='FF0000'>#{printed_on.strftime("%a, %d %b '%y at %I:%M%p") }</color> by Odogwudozilla", :inline_format => true, :color => "24292E"}
      
        end
    
    puts "$$*************Process completed and PDF '#{@page_title}.pdf' created************$$"
    #byebug
    
  end

end 


SiteScraper.new.nairaland