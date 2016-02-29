class Response

  CONTENT_LENGTH_HEADER = "Content-Length"

      RESPONSE_PHARASES = {
      200 => 'OK',
      201 => 'Successfully Created',
      304 => 'Not Modified',
      400 => 'Bad Request',
      401 => 'Unauthorized',
      403 => 'Forbidden',
      404 => 'Not Found',
      500 => 'Internal Server Error'
    }

  def initialize(params)

    @version = "HTTP/1.1"
    @headers = {
                "Content-Type"      =>  "text/html",
                "Content-Length"    =>  "0",
                "Content-Language"  =>  "en",
#                "WWW-Authenticate"  =>  "Basic"
               }

    @body = "<html>
               <body>
                  This is my response
               </body>
             </html>"

    if ! @body.empty?
        @headers["Content-Length"] = @body.length
    end
    @response_code=200
    @reason_phrase="OK"
  end
 
  def to_s
    str = ""
    str = str + @version.to_s
    str = str + " "
    str = str + @response_code.to_s
    str = str + " "
    str = str + @reason_phrase
    #str = str + "\n"
   
    _content_length =0
    
    @headers.each do |key,val| 
       str = str + "\n#{key}: #{val}"
       if key.casecmp(CONTENT_LENGTH_HEADER) == 0
              _content_length =val.to_i
       end
    end
 
    if _content_length > 0
       str = str+ "\n\n" + @body
    end
 
   return str
 end
end

#test_response = Response.new
#puts test_response.to_s
