require_relative 'header_collection'
class Request
 attr_accessor :content, :http_method, :uri, :version, :headers, :body, :params

    def initialize(request)
      
      @content = request.split("\n",2)
      non_header_info = @content[0].to_s.split(" ")
      @http_method = non_header_info[0]
      @uri =  non_header_info[1]
      @version = non_header_info[2]
      @headers = HeaderCollections.new
      @params = Array.new
    end

    #Parse the request
    def parse
      
      unparsed_query = Array.new
      parsed_query = Array.new
      unparsed_query = @uri.to_s.split('?')[1].to_s.split('&')
      parsed_query= unparsed_query.map{|x| x.split("=")}
      @params = Hash[parsed_query.map{|key, value| [key, value.strip]}]
      @uri = @uri.to_s.split('?', 2)[0]
      parsed_headers = Array.new
      flagged = 0

      @content[1].each_line("\n") do |line|
        if(line.chomp != nil)
          parsed_headers.push line.split(":", 2)
        end
      end
        #puts "PARSED HEADERS"
      #puts parsed_headers
      parsed_headers.map do |key, value| 
           @headers.add(key, value.to_s.strip)
      end
      content_length = @headers.get("Content-Length").to_i
    end

   def read_body(text)
     @body = text
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

end
