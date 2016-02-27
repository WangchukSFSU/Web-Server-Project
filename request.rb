class Request
=begin EXAMPLE HTTP REQUEST USED FOR TESTING
POST /cgi-bin/process.cgi HTTP/1.1
User-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT)
Host: www.tutorialspoint.com
Content-Type: application/x-www-form-urlencoded
Content-Length: length
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive

licenseID=string&content=string&/paramsXML=string
=end
 attr_accessor :content, :http_method, :uri, :version, :headers, :body, :params
    # Request creation 

    def initialize(request)
      
      @content = request.split("\n")
      #puts "REQUEST INFO__________________"
      puts @content
      #puts "REQUEST INFO DONE_____________"
      non_header_info = @content[0].split(" ")
      #puts non_header_info
      #puts "NON HEADER INFO"
      @http_method = non_header_info[0]
      @uri =  non_header_info[1]
      #puts @uri.class
      @version = non_header_info[2]
      #not sure why version needs a split? uncomment if needed
      #@version = non_header_info[2].split
      #puts @http_method
      #puts @uri
      #puts @version
      #puts "NON_HEADER INFO DONE"
      @headers = Array.new
      @body = Array.new
      @params = Array.new
    end

    #Parse the request
    def parse

      
      unparsed_query = Array.new
      parsed_query = Array.new
      unparsed_query = @uri.to_s.split('?')[1].to_s.split('&')
      #puts unparsed_query
      parsed_query= unparsed_query.map{|x| x.split("=")}
      @params = Hash[parsed_query.map{|key, value| [key, value.strip]}]
      @uri = @uri.split('?', 2)[0]


      index = 0
      flagged = 0
      unparsed_headers = Array.new
      parsed_headers = Array.new
      1.upto(@content.length - 1) { |i| 
      if(flagged == 1 && @content[i].length == 0)
	#puts "FOUND"
        index = i + 1
        break
      end
      unparsed_headers.push @content[i]
      if(flagged == 0 && (@content[i].include? "Content-Length") == true)
        #puts "FOUND 2"
        flagged = 1
      end
      }
      if(flagged != 0)
        index.upto(@content.length - 1) { |i|
          @body.push @content[i]
        }
      end
      parsed_headers = unparsed_headers.map{|x| x.split(":", 2)}
      #puts "PARSED HEADERS"
      #puts parsed_headers
      #puts "PARSED HEADERS DONE"
      @headers = Hash[parsed_headers.map{|key, value| [key, value.to_s.strip]}]
      return self
    end

   def to_s
     puts "----------- REQUEST PARSED -------"
     puts "METHOD: #{http_method} ", "URI: #{uri} ",  "VERSION: #{version}\n\n"

     if(@params.length != 0)
       puts "PARAMETERS:"
       @params.each do |key, array|
         puts "#{key}: #{array}"
       end
     end

     puts "HEADERS:"
     @headers.each do |key, array|
       puts "#{key}: #{array}"
     end  
     
     if(@body.length != 0)
       puts "BODY:", @body
     end
   end
end
