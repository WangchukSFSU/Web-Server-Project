require_relative 'request'
require_relative 'response'
require_relative 'resource'
require_relative 'response_factory'

# this class is respoisble for handling single request. It reads incoming 
# request, and writes a response to socket  
module WebServer
   class Worker
      attr_reader :client,:conf,:mime_types,:logger

     def initialize(client,conf,mime,logger)
       @client = client
       @logger = logger
       @conf = conf
       @mime_types = mime
     end

    # handles a single web client request.
     def handle_request
        request_string = ""
   
#       begin

          begin
            
               while next_line_readable?(client)
                  line = client.gets
                  if(line == "\r\n")
                    break
                  end
                  request_string <<  line.chop
                  request_string << "\n"
               end

               request = Request.new(request_string)
               status = request.parse
               if(status != 0) 
                  content_length = request.headers.get("Content-Length").to_i
                  body = client.readpartial(content_length)
                 request.read_body(body)
               end
               puts request.to_s
          rescue
              if ! client.closed?
                response = ResponseFactory.create_response("400")
                puts "-------Sending response:------ "
                puts response.to_s
                puts  "\n\n"
                client.print response
                client.close
                return
               end
          end

         resource = Resource.new(request.uri, @conf, @mimes,request.http_method)
         absolute_path = resource.resolve
         puts "------------ absolute path --------" + absolute_path + "\n"

         response = ResponseFactory.create(request,resource,
                                        @conf.document_root,@mime_types)
         @logger.write(request,response)
         puts "-----Sending response -------- "
         puts response.to_s
         puts "\n\n"
         client.print response
         client.close

#     rescue
#         if ! client.closed?
#           response = ResponseFactory.create_response("500")
#           puts "---------Sending response-------- " 
#           puts response
#           puts  "\n\n"
#           client.print response 
#          client.close
#         end
#      end
    end
 

   # fd be nil if next line cannot be read
   def next_line_readable?(socket)
      readfds, writefds, exceptfds = select([socket], nil, nil, 0.1)
      readfds
   end


 end
end
