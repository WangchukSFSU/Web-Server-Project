class Response

  CONTENT_LENGTH_HEADER = "Content-Length"

  attr_reader :http_version,:response_code,:reason_phrase,:headers,:body
   
  REASON_PHRASE = {"200" => "OK",
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
                   "204" => "No Content"
                }

  def initialize(params)
    @headers = params.fetch(:headers)
    @http_version = params.fetch(:http_version)
    @response_code= params.fetch(:response_code)
#    @reason_phrase = params.fetch(:reason_phrase)
    @body = params.fetch(:body)

    if @body.nil? || @body.empty? 
       @headers.add("Content-Length","0")
    else
       @headers.add("Content-Length",@body.length)
     end
  end
 
  def to_s
=begin    
   result =  @http_version
   result << " "
   result << @response_code 
   result <<  " "
   result  << REASON_PHRASE[@response_code]
   result << "\n"
   result <<  headers.to_s
   if ! body.empty?
    result << "\n" << @body
   end
  result
=end


<<RESULT
#{http_version} #{response_code} #{REASON_PHRASE[@response_code]}
#{headers}

#{body}  
RESULT

 end
end

#test_response = Response.new
#puts test_response.to_s
