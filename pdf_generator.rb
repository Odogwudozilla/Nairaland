    # encoding: utf-8
    # require_relative 'nairaland'

    
    class GenPdf 
      def self.gen_pdf

        # output the result to PDF file
        Prawn::Document.generate("#{$page_title}.pdf") do
          # Custom font families
          font_families.update(
            "Roboto"=>{:normal =>"fonts/Roboto/Roboto-Regular.ttf", :bold =>"fonts/Roboto/Roboto-Regular.ttf", :italic =>"fonts/Roboto/Roboto-Regular.ttf", :bolditalic =>"fonts/Roboto/Roboto-Regular.ttf"}, 

            "OpenSans"=>{:normal =>"fonts/Open_Sans/OpenSans-Regular.ttf", :bold =>"fonts/Open_Sans/OpenSans-Regular.ttf", :italic =>"fonts/Open_Sans/OpenSans-Regular.ttf", :bold_italic => "fonts/Open_Sans/OpenSans-Regular.ttf"}
          
          )
          font "OpenSans"
          default_leading 5

          # Print the summary
          font_size(25) {text "SUMMARY of Top Posts \n", :color => "FF0000", :align => :center} #Print post topic
          $top_posts.each do |top|
            font_size(11) {text "<color rgb='0000FF'>#{top}</color> \n\n", :align => :justify, :inline_format => true} # print the post message

          end # end top_posts

          start_new_page

            # Iterate through and create PDF
          $combined_data_rank.each do |key,val|
            next puts "this data was skipped because appreciation less than 5" if val[:post_likes] < 5 



            font_size(18) {text "#{key[:topic]} \n", :color => "0000FF"} #Print post topic
            font_size(9) {text "Posted (on page <color rgb='FF00FF'>#{val[:page_number].to_i + 1}</color>) by:", :inline_format => true} # Print page number
            font_size(14) {text "#{key[:username]}", :color => "FF0000"} # Print the username
            font_size(9) {text "#{key[:date]} \n"} # print the date
            font_size(9) {text "<color rgb='0000FF'><a href='#{key[:topic_target]}'>Click here to Visit page<a/></color>\n", :inline_format => true} # print the target link for the post
            
            move_down 10
            font_size(14) {text "Message:", :color => "FF00FF"} 

            span(490, :position => :center) do
              font_size(12) {text "#{val[:post_text]}. \n", :align => :left, :indent_paragraphs => 20, :inline_format => true} # print the post message
              
            end # end span

            #font "Roboto"
            text "Number of likes: <color rgb='0000FF'> #{val[:post_likes]}</color>", :inline_format => true

            # Configure the horizontal line
            stroke_color "24292E"
            x = 100
            y = 400
            7.times do 
              
              stroke do
                horizontal_line x, y
              end #end stroke
      
              x += 20
              y -= 20
              move_down 5
            end #end 7.times

            move_down 100

            y_position = cursor - 0
      
            start_new_page if y_position < 150 
      
          end #end combined_data_rank
      
          move_down 30
          font_size(9) {text "Data scrapped from <color rgb='0000FF'>#{$url}</color>, <color rgb='FF0000'>#{$printed_on.strftime("%a, %d %b '%y at %I:%M%p") }</color> by Odogwudozilla", :inline_format => true, :color => "24292E"}
          
          ######################################################################
          # Method for Drawing Pyramid
          
            13.times {|n|
              text "#{' ' * (13 - n)}"
              text "#{'*' * (2 * n + 1)}", :align => :center
            }
        
          text " ODOGWUDOZILLA na ekene gi", :align => :center

      
        end #end Prawn
        
      end # end self.gen_pdf

    end # end GenPdf
