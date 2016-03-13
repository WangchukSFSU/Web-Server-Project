require_relative 'response'
require_relative 'htaccess_checker'

# this class is resposible for generating response 

module WebServer
  class ResponseFactory

      # class method to generate appropriate response
     def self.create(request,resource,document_root,mime)
       if (! resource.script? resource.uri) && (! resource.alias? resource.uri)
       
           access_checker = HtaccessChecker.new(resource.uri_without_doc_root,
                                          request,document_root)

           if access_checker.protected?
             if ! access_checker.can_authorized?
                return self.create_response("401")
             elsif ! access_checker.authorized?
                return self.create_response("403")
             end
           end
        end
       
         if (request.http_method.casecmp("PUT") != 0) &&
            (! File.file?(resource.resolved_uri))
              return self.create_response("404")
         end

         if resource.script?(resource.uri)
           return create_cgi_response(request,resource.resolved_uri,mime)       
         end
 
      return self.handle_method(request,resource,document_root,mime)
    end

    # handles GET,PUT,DELETE and HEAD requests
    def self.handle_method(request,resource,document_root,mime)
      case request.http_method
       when "GET"
        # if it is GET request, return contents of file
         return self.handle_get_request(resource.resolved_uri,mime)
 
       when "HEAD"
         # if it is HEAD request, generate 200 without any content
         return self.create_response("200")
     
       when "PUT"
         # if it is PUT request, create a new file
         path = resource.resolved_uri
         if (File.directory? path) || (! File.directory? (File.dirname path))
           return self.create_response("404")
         end
         self.create_file(resource.resolved_uri,request.body)
         return self.create_response("201")
  
       when "DELETE"
          # if it is DELETE request, delete the file
         File.delete(resource.resolved_uri)
         return self.create_response("204")
      
       else
          return self.create_response("501")
     end
  end

  # handles CGI script. calls the script and returns the generated response
  def self.create_cgi_response(request,script,mime)
     if request.http_method.casecmp("GET") != 0
       return self.create_response("501")
     end
    
     if(! File.executable? script)
        return  self.handle_get_request(script,mime)
     end
     modified_headers = request.headers.uppercase
     cgi_response = IO.popen([modified_headers,script]).read
     hc = HeaderCollections.new()
     time = Time.new
     hc.add("Date",time.inspect)
     Response.new({:cgi_response => cgi_response,
                 :headers => hc,
                 :response_code => "200",
                 :http_version => "HTTP/1.1",})
   end

  # helper methods

   def self.handle_get_request(path,mime) 
     contents,size = self.get_file_contents(path)
     extension =  File.extname(path)
     mime_type = mime.get_mime_type(extension[1..-1])
     if  mime_type.nil?
        mime_type = "text/html"
     end
     return self.generate_200_response(contents,size,mime_type)
   end

   def self.create_response(response_code)
      hc = self.generate_headers
      response = Response.new(:headers => hc,
		     :response_code => response_code,
		     :http_version => "HTTP/1.1",
		     :body => nil)
      response
   end

    def self.get_file_contents(path)
       file = File.open(path, "r")
       contents = file.read
       file.close
       size = File.size(path)

      return contents,size
    end
   
    def self.create_file(path,contents)
      out_file = File.new(path, "w")
      out_file.puts(contents)
      out_file.close
    end
   
   def self.generate_200_response(contents,size,mime)
         hc = HeaderCollections.new()
         hc.add("Content-Type",mime)
         hc.add("Content-Length",size)
         hc.add("Content-Language","en")

        response = Response.new(:headers => hc,
                     :response_code => "200",
                     :http_version => "HTTP/1/1",
                     :body => contents)

        response
   end

   def self.generate_headers
      hc = HeaderCollections.new()
      hc.add("Content-Type","text/html")
      hc.add("Content-Length","0")
      hc.add("Content-Language","en")
      hc
   end

 end 
end
