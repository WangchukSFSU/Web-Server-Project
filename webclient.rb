

class Request
    attr_accessor :content, :http_method, :uri, :version, :headers, :body
    # Request creation 
    def initialize(request)
      
      @content = request.split(" ")
      @http_method = @content[0]
      @uri =  @content[1]
      @version = @content[2]     
      @headers = parse_header    
      @body  || = parse_body
 
    end

    #Parse the request
    def parse
      http_method, uri, version 
      headers, body
      uri = uri.split('?')[0]    
      return http_method, uri, version, headers, body
    end

	def parse_header
	end


    def parse_body  
      body = @content[4..-1].join("\n")
      body
    end



 
end


