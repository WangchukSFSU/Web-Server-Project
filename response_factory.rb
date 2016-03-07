require_relative 'response'

class ResponseFactory

   def self.create(request,resource,document_root)
     # response = Response.new()
    #  absolute_path = resource.resolve
       puts "response factory " + resource.uri_without_doc_root
     access_checker = HtaccessChecker.new(resource.uri_without_doc_root,
                                          request,document_root)

        if access_checker.protected?
          if ! access_checker.can_authorized?
             return self.create_response("401")
             puts "401"
            #return 401
          elsif ! access_checker.authorized?
             puts "403"
             return self.create_response("403")
             #return 403
          end
        else
             puts "NOT PROTECTED"
        end

        if (!request.http_method == "PUT") && (! File.exists?(resource.resolved_uri))
               puts "404"
              return self.create_response("404")
        end

       if resource.script?(resource.uri)
          #
           return self.create_response("200")
       end

       case request.http_method
        when "GET"
           contents,size = self.get_file_contents(resource.resolved_uri)
           return self.generate_200_response(contents,size)
        when "HEAD"
           return self.create_response("200")
        when "PUT"
           self.create_file(resource.resolved_uri,request.body)
           return self.create_response("201")
        when "DELETE"
           File.delete(resource.resolved_uri)
           return self.create_response("204")
        else
         #    raise exception
       end

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
   
   def self.generate_200_response(contents,size)
         hc = HeaderCollections.new()
         hc.add("Content-Type","text/html")
         hc.add("Content-Length",size)
         hc.add("Content-Language","en")
         #                "WWW-Authenticate"  =>  "Basic"

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
