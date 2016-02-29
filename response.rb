class Response

  CONTENT_LENGTH_HEADER = "Content-Length"

  attr_reader :http_version,:response_code,:reason_phrase,:headers,:body
   
  REASON_PHRASE = {200 => "OK",
                   404 => "Page Not Found",
                   401 => "Unauthorized",
                   500 => "Internal Server Error",
                   400 => "Bad Request"  }

  def initialize(params)
    @headers = params.fetch(:headers)
    @http_version = params.fetch(:http_version)
    @response_code= params.fetch(:response_code)
#    @reason_phrase = params.fetch(:reason_phrase)
    @body = params.fetch(:body)
=begin
=======
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

>>>>>>> 2dcd6c7956e5aa0cbf7c2076466ddf1e14bf9f1c
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
=end
    if ! @body.empty?
        @headers.add("Content-Length",@body.length)
    else
       @headers.add("Content-Length","0")
     end
    @response_code=200
    @reason_phrase="OK"
  end
 
  def to_s
=begin
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

=end
<<-RESULT
#{http_version} #{response_code} #{REASON_PHRASE[response_code]}
#{headers}.to_s

#{body}  
RESULT
 end
end

#test_response = Response.new
#puts test_response.to_s
