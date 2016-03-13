# this class represents response to be sent to web client

module WebServer
  class Response

    CONTENT_LENGTH_HEADER = "Content-Length"
    @cgi_response_flag = false
    attr_reader :http_version,:response_code,:reason_phrase,:headers,:body,
              :cgi_response
   
    REASON_PHRASE = {
                   "200" => "OK",
                   "404" => "Page Not Found",
                   "401" => "Unauthorized",
                   "500" => "Internal Server Error",
                   "400" => "Bad Request", 
                   "201" => 'Successfully Created',
                   "304" => 'Not Modified',
                   "400" => 'Bad Request',
                   "401" => 'Unauthorized',
                   "403" => 'Forbidden',
                   "404" => 'Not Found',
                   "500" => 'Internal Server Error',
                   "204" => "No Content",
                   "501" => "Not Implemented"
                }

   # initialize instance variables 
   def initialize(params)
      @headers = params.fetch(:headers)
      @http_version = params.fetch(:http_version)
      @response_code= params.fetch(:response_code)
      #    @reason_phrase = params.fetch(:reason_phrase)

      if params.has_key?(:body)
        @body = params.fetch(:body)
   
        if @body.nil? || @body.empty? 
           @headers.add("Content-Length","0")
        else
           @headers.add("Content-Length",@body.length)
        end
      end

      if params.has_key?(:cgi_response)
        @cgi_response = params.fetch(:cgi_response)
        @cgi_response_flag = true
      end
   end
 
  # returns string representation of response object
   def to_s
 
     if @cgi_response_flag == true
<<RESULT
#{http_version} #{response_code} #{REASON_PHRASE[@response_code]}
#{headers}
#{cgi_response}  
RESULT

     else
<<RESULT
#{http_version} #{response_code} #{REASON_PHRASE[@response_code]}
#{headers}

#{body}  
RESULT
     end
   end

 end
end

