class Logger

 attr_reader :filepath,:file

 def initialize(filepath)
   @filepath = filepath
 end

 def write(request,response) 
    host = request.headers.get("Host")
  #  auth_header = request.headers.get("Authorization")
      
    File.open(@filepath, 'a') do |file|
      file.write("\n\n" + host)
      file.write("   " + get_user(request))
     file.write("\n" + Time.new.inspect)
     request_parameters = "\n" + request.http_method + 
                          " "  + request.uri + " " + request.version
     file.write(request_parameters)
     file.write("\n" + response.response_code)
     if ! response.body.nil? 
     file.write(" " + response.body.length.to_s)
     end
    end  
 end

  def get_user(request)
    user = ""
    auth_header =  request.headers.get("Authorization")
    if(! auth_header.nil? && ! auth_header.empty?)
     encryptheader = auth_header.split(" ")[1]
      if ! encryptheader.nil?
        decryptheader = Base64.decode64(encryptheader)
        key,value = decryptheader.split(':')
        user = key
     end
    end

    if user.empty?
       user = "Unknown"
    end

   user
  end

end
