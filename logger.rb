class Logger

 attr_reader :filepath,:file

 def initialize(filepath)
   @filepath = filepath
 end

 def write(request,response) 
    host = request.headers["Host"]
    auth_header = request.headers["Authorization"]
    File.open(@filepath, 'a') do |file|
        file.write("\n\n" + host)
        if(! auth_header.nil? && ! auth_header.empty?)
           file.write("   " + auth_header)
        end

     file.write("\n" + Time.new.inspect)
     request_parameters = "\n" + request.http_method + 
                          " "  + request.uri + " " + request.version
     file.write(request_parameters)
     file.write("\n" + response.response_code + " " + response.body.length.to_s)
    end  
 end

end
