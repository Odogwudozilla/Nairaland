require 'fileutils'
require_relative 'urls_nairaland' # call the class methods in the other file
require_relative 'kontrol'
require_relative 'pdf_generator'
require 'highline/import'
require 'httparty'
require 'nokogiri'
require 'open-uri'
require 'prawn'
require 'byebug'

class SiteScraper

  
  # Setting the preliminaries
  def prelim
    
    $printed_on = Time.now # Define the current date-time
    
    #Defining the page numbers in order to iterate through it
    $page_nos = []
    
    Kontrol.prompter    
    MyUrls.urls_cache    
    $urls_list |= [$chosen_site] #checks if the supplied link exists in the urls_list and appends to list if not
    File.open("urls_nairaland.txt", "w+") { |f| $urls_list.each { |url| f.puts(url)} } # writes the new value of the URL_list to file.

    $url = $chosen_site #grab the URL from the list on MyUrls class
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
    
    # picking the first or second array element as the highest page (still trying to figure out how to make this cleaner as a strange number keeps intermittently showing up as first array element. So I assume the thread page cannot go above 1000 pages before the thread is closed)
     
    $highest_page = pages_arr[0].to_i > 1000 ? pages_arr[1].to_i : pages_arr[0].to_i
     
    puts "The highest page in this session is #{$highest_page}"
    
    
    $page_nos = *(0..$highest_page) # set array range for page numbers to loop through

  end #end prelim


  

  # Does the actual dirty work
  def nairaland
  
    $top_posts = []
    head_data = [] # set empty array to collate table heading data on each page
    post_data =[] # set empty array to collate table body data on each page
    
    #Iterating through the page numbers
    $page_nos.each do |page_no|
  
      urle = $url + "/" + page_no.to_s
      unparsed_page = HTTParty.get(urle)
      parsed_page = Nokogiri::HTML(unparsed_page)
      
      
      tmain = parsed_page.css('div.body table tr td')
      
      thead_all = tmain.css('.pu') #The table headings
      
      thead_all.each do |thead|
        thread_topic = thead.css('a[href]').text
        linke = thead.css('a[name]')
        link_target = linke[0]
        link_target1 = link_target.first[1]
        user_poster = thead.css('a.user').text
        post_date = thead.css('span.s').text
        
        # push head_data to array
        head_data << {:topic => thread_topic,
          :username => user_poster,
          :topic_target => urle + "#" + link_target1, #linke[0].attribute("href") == nil ? "dead link" : 
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
      #byebug
      puts "************Data for page #{page_no} added out of #{$highest_page}************"
      
    end
    # byebug
    # head_data = head_data.compact
    # post_data = post_data.compact
    combined_data = head_data.zip(post_data).to_h # Combine both headings data and body data into a hash of arrays
    
    #byebug
    $combined_data_rank = combined_data.sort_by{ |key, value| value[:post_likes] }.reverse.take(50) # sort and rank the combined data hash by the number of likes for each post and then take only the top 50

    puts "[b]These are the top #{$combined_data_rank.count} posts as at today: #{$printed_on.strftime("%a, %d %b '%y at %I:%M%p") }[/b]"

    $combined_data_rank.each do |key, value|
      
      puts "#{key[:topic_target]} - (#{value[:post_likes]} likes)\n\n"
      $top_posts << "#{key[:topic_target]} - (#{value[:post_likes]} likes)"

    end #end combined_data_rank
    
    GenPdf.gen_pdf

    # Moves the PDF(s) to own folder
        pdf_dir = "PDFs_generated"
        pdf_file = Dir.glob("*.{pdf,xps}")
        pdf_file.each { |pdf| FileUtils.mv pdf, pdf_dir}
    
    puts "$$*************Process completed and PDF '#{$page_title}.pdf' created and moved to '#{pdf_dir}' folder ************$$"
    #byebug
    
  end # end nairaland

end # end SiteScraper


#SiteScraper.new.konsole
SiteScraper.new.prelim
SiteScraper.new.nairaland