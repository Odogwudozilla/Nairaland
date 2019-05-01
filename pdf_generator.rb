    # require_relative 'nairaland'
    
    class GenPdf 
      def self.gen_pdf

        # output the result to PDF file
        Prawn::Document.generate("#{$page_title}.pdf") do
          font_families.update("Roboto"=>{:normal =>"fonts/Roboto/Roboto-Regular.ttf", :bold =>"fonts/Roboto/Roboto-Bold.ttf", :italic =>"fonts/Roboto/Roboto-Italic.ttf"}, "OpenSans"=>{:normal =>"fonts/Open_Sans/OpenSans-Regular.ttf", :bold =>"fonts/Open_Sans/OpenSans-Bold.ttf", :italic =>"fonts/Open_Sans/OpenSans-Italic.ttf"})

          $combined_data_rank.each do |key,val|
            next puts "this data was skipped because appreciation less than 5" if val[:post_likes] < 5 
            puts "poster is #{key[:username]} on page #{val[:page_number]} "

            font "OpenSans"
            default_leading 5

            # post_link = "https://www.nairaland.com" + val[:topic_link].to_s
            # puts val[:topic_link]

            font_size(18) {text "#{key[:topic]} \n", :color => "0000FF"}
            font_size(9) {text "Posted (on page <color rgb='FF00FF'>#{val[:page_number]}</color>) by:", :inline_format => true} 
            font_size(14) {text "#{key[:username]}", :color => "FF0000"} 
            font_size(9) {text "#{key[:date]} \n"} 
            # font_size(9) {text "<color rgb='0000FF'><a href='#{post_link}'>Visit page<a/></color>\n", :inline_format => true}
            
            move_down 10
            font_size(14) {text "Message:", :color => "FF00FF"}

            span(490, :position => :center) do
              font_size(12) {text "#{val[:post_text]}. \n", :align => :left, :indent_paragraphs => 20, :inline_format => true} 
              
            end
            font "Roboto"
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
      
        end #end Prawn

      end 

    end 

    # GenPdf.new.gen_pdf