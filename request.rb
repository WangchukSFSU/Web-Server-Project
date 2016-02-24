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
      non_header_info = @content[0].split(" ")
      @http_method = non_header_info[0]
      @uri =  non_header_info[1].split('?')[0]
      @version = non_header_info[2].split
      @headers = Array.new
      @body = Array.new
      @params = Array.new
    end

    #Parse the request
    def parse

      
      unparsed_query = Array.new
      parsed_query = Array.new
      unparsed_query = @content[1].split('?')[1].split('&')
      parsed_query= unparsed_query.map{|x| x.split("=")}
      @params = Hash[parsed_query.map{|key, value| [key, value.strip]}]



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
      parsed_headers = unparsed_headers.map{|x| x.split(":")}
      @headers = Hash[parsed_headers.map{|key, value| [key, value.strip]}]
      return self
    end

   def to_s
   puts "----------- REQUEST PARSED -------"
   print "Method: ",http_method,"URI: ", uri ,"Version: ", version 

@params.each do |key, array|

   @headers.each do |key, array|
  puts "#{key}-----"
  puts array
end  
  print "BODY: ", body
   end
end
