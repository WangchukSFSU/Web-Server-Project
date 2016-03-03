require_relative 'response'
class ResponseFactory
   def self.create(request,resource,absolute_path)
     # response = Response.new()
    #  absolute_path = resource.resolve
     access_checker = HtaccessChecker.new(absolute_path,request)

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

        if ! File.exists?(absolute_path)
               puts "404"
              return self.create_response("404")
        end



    file = File.open(absolute_path, "r")
    contents = file.read
    file.close

    size = File.size(absolute_path)
     #create a response
         hc = HeaderCollections.new()
         hc.add("Content-Type","text/html")
         hc.add("Content-Length",size)
         hc.add("Content-Language","en")
         #                "WWW-Authenticate"  =>  "Basic"
         response = Response.new(:headers => hc,
                              :response_code => "200",
                              :http_version => "HTTP/1/1",
                              :body => contents)
        #      test_response = Response.new



   end
    
   def self.create_response(response_code)
    hc = self.generate_headers
   response = Response.new(:headers => hc,
		     :response_code => response_code,
		     :http_version => "HTTP/1.1",
		     :body => "")
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
