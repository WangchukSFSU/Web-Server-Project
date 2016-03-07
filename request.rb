require_relative 'header_collection'
class Request
 attr_accessor :content, :http_method, :uri, :version, :headers, :body, :params
    # Request creation 

    def initialize(request)
      
      @content = request.split("\n",2)
      #puts "REQUEST INFO__________________"
      #puts @content
      non_header_info = @content[0].to_s.split(" ")
      #puts non_header_info
      @http_method = non_header_info[0]
      @uri =  non_header_info[1]
      @version = non_header_info[2]
      #not sure why version needs a split? uncomment if needed
      #@version = non_header_info[2].split
      #puts @http_method
      #puts @uri
      #puts @version
      @headers = HeaderCollections.new
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
      @uri = @uri.to_s.split('?', 2)[0]
      parsed_headers = Array.new
      flagged = 0
      
      
      unparsed_headers = @content[1].to_s.split("\n\n")
      #puts "TESTING SPLIT"
      #puts unparsed_headers[0]
      #puts "TEST 2", unparsed_headers[1]
      #puts 'ENDING SPLIT'


      unparsed_headers[0].each_line("\n"){ |line|
        if(line.chomp != nil)
          parsed_headers.push line.split(":", 2)
        end
      }
      #puts "PARSED HEADERS"
      #puts parsed_headers
      parsed_headers.map{|key, value| @headers.add(key, value.to_s.strip)
      }
      content_length = @headers.get("Content-Length").to_i
      if(content_length != nil && content_length > 0)
        @body = unparsed_headers[1].byteslice(0..content_length)
      end
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
     puts @headers
      
     puts
     if(! @body.nil? && @body.length != 0)
       puts "BODY:", @body
     end
   end

   def has_key?(key)
     @headers.has_key?(key)
   end
end
